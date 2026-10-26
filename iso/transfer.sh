# Shared by the scripts that read or write the transfer card: prepended to
# their text, not run on its own.

die() {
  echo "$@" >&2
  exit 1
}

transfer_umount() {
  [ -n "${transfer_mnt:-}" ] || return 0
  umount "$transfer_mnt"
  rmdir "$transfer_mnt"
  transfer_mnt=
}

# Mounts the only filesystem labelled TRANSFER with options $1, or uses the
# directory $2 when given (a card already mounted), and sets $transfer. Two
# cards with that label would make /dev/disk/by-label pick one at random.
transfer_mount() {
  local devices
  if [ -n "${2:-}" ]; then
    [ -d "$2" ] || die "No such directory: $2"
    transfer=$2
    return
  fi
  mapfile -t devices < <(blkid -c /dev/null -t LABEL=TRANSFER -o device || true)
  case ${#devices[@]} in
    0) die "No filesystem labelled TRANSFER: plug the transfer card." ;;
    1) ;;
    *) die "Several filesystems labelled TRANSFER: ${devices[*]}" ;;
  esac
  local mnt
  mnt=$(mktemp -d)
  mount -o "$1" "${devices[0]}" "$mnt" || { rmdir "$mnt"; exit 1; }
  transfer_mnt=$mnt
  trap transfer_umount EXIT
  transfer=$transfer_mnt
}

# Asks for an explicit yes: a bare Enter must not sign or broadcast.
confirm() {
  local answer
  read -rp "$1 Type yes: " answer
  [ "$answer" = yes ] || die "Aborted."
}

psbt_field() {
  tr -d '[:space:]' < "$1" | { cat; echo; } | bitcoin-cli -stdin decodepsbt | jq -r "$2"
}
