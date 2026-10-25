usage() {
  echo "Usage: server-backup [--init] LABEL" >&2
  exit 1
}

init=
while [ $# -gt 0 ]; do
  case "$1" in
    --init) init=1; shift ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -eq 1 ] || usage
label=$1
device=/dev/disk/by-label/$label

[ "$(id -u)" -eq 0 ] || {
  echo "server-backup must run as root" >&2
  exit 1
}

[ -e "$device" ] || {
  echo "No disk labelled $label (lsblk -o NAME,LABEL,SIZE)" >&2
  exit 1
}

mnt=$(mktemp -d)
mount "$device" "$mnt"
trap 'umount "$mnt"; rmdir "$mnt"' EXIT

export RESTIC_REPOSITORY=$mnt/restic

if [ -n "$init" ]; then
  restic init
fi

restic backup --one-file-system "$PHOTOS_DIR"
restic check
restic snapshots --compact

echo "Backup to $label complete, the disk is unmounted on exit."
