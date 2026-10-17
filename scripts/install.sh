usage() {
  echo "Usage: install KEY_FILE [--disk DEVICE] [--mount DIR] HOST" >&2
  exit 1
}

[ $# -ge 1 ] || usage
key=$(realpath "$1")
shift

disk=
mnt=/mnt

while [ $# -gt 0 ]; do
  case "$1" in
    --disk) disk=$2; shift 2 ;;
    --mount) mnt=$2; shift 2 ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -eq 1 ] || usage
host=$1

[ "$(id -u)" -eq 0 ] || {
  echo "install must run as root" >&2
  exit 1
}

[ -d "$FLAKE/hosts/$host" ] || {
  echo "Unknown host: $host" >&2
  echo "For new hardware, create hosts/$host from:" >&2
  echo "  nixos-generate-config --no-filesystems --show-hardware-config" >&2
  exit 1
}

read -rsp "Password (LUKS and $USER_NAME): " password; echo
read -rsp "Confirm password: " confirm; echo
[ -n "$password" ] && [ "$password" = "$confirm" ] || {
  echo "Passwords are empty or do not match" >&2
  exit 1
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
(umask 077; printf '%s' "$password" > "$tmp/password")

disko_args=(--mode "destroy,format,mount" --root-mountpoint "$mnt" --argstr passwordFile "$tmp/password")
if [ -n "$disk" ]; then disko_args+=(--argstr device "$disk"); fi
disko "${disko_args[@]}" "$FLAKE/hosts/$host/disko.nix"

nixos-install --root "$mnt" --flake "path:$FLAKE#$host" --no-root-passwd

printf '%s:%s\n' "$USER_NAME" "$password" | nixos-enter --root "$mnt" -c chpasswd
unset password confirm
rm -f "$tmp/password"

bootstrap --root "$mnt" --host "$host" "$key"

echo "Installation complete, you can reboot."
