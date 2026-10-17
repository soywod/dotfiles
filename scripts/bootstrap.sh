usage() {
  echo "Usage: bootstrap [--root DIR] [--host NAME] KEY_FILE" >&2
  exit 1
}

root=/
host=$(hostname)

while [ $# -gt 0 ]; do
  case "$1" in
    --root) root=$2; shift 2 ;;
    --host) host=$2; shift 2 ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -eq 1 ] || usage
key=$(realpath "$1")

read -r _ mrconfig known_hosts < <(grep "^$host " "$HOSTS_FILE") || {
  echo "Unknown host: $host" >&2
  exit 1
}

home="${root%/}/home/$USER_NAME"
[ -d "$home" ] || {
  echo "Home directory not found: $home" >&2
  exit 1
}

tmp=$(mktemp -d)
export GNUPGHOME="$tmp/gnupg"
cleanup() {
  gpgconf --kill gpg-agent || true
  rm -rf "$tmp"
  if [ -n "${tmp_mrconfig:-}" ]; then rm -f "$home/.mrconfig"; fi
}
trap cleanup EXIT

mkdir -m 700 "$GNUPGHOME"
cat > "$GNUPGHOME/gpg-agent.conf" <<EOF
pinentry-program $(command -v pinentry-curses)
enable-ssh-support
EOF

GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye > /dev/null

echo "Importing GPG key…"
gpg --import "$key"

fpr=$(gpg --list-secret-keys --with-colons | awk -F: '/^fpr/ { print $10; exit }')
echo "$fpr:6:" | gpg --import-ownertrust

grip=$(gpg --list-secret-keys --with-colons --with-keygrip | awk -F: '
  /^(sec|ssb)/ { caps = $12 }
  /^grp/ && caps ~ /a/ { print $10; exit }
')
[ -n "$grip" ] || {
  echo "No authentication subkey found in $key" >&2
  exit 1
}
echo "$grip" > "$GNUPGHOME/sshcontrol"

SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AUTH_SOCK
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=$known_hosts -o StrictHostKeyChecking=yes"

echo "Cloning repositories…"
if [ ! -e "$home/.mrconfig" ]; then
  tmp_mrconfig=1
  cp "$mrconfig" "$home/.mrconfig"
fi
(cd "$home" && HOME="$home" mr checkout)

echo "Installing GPG key…"
target="$home/.gnupg"
mkdir -p "$target/private-keys-v1.d"
chmod 700 "$target" "$target/private-keys-v1.d"
cp "$GNUPGHOME"/private-keys-v1.d/*.key "$target/private-keys-v1.d/"
gpg --export "$fpr" | gpg --homedir "$target" --import
echo "$fpr:6:" | gpg --homedir "$target" --import-ownertrust
gpgconf --homedir "$target" --kill all || true

if [ "$root" != / ]; then
  nixos-enter --root "$root" -c "chown -R $USER_NAME:users /home/$USER_NAME"
fi

echo "Done. Authentication subkey keygrip: $grip"
