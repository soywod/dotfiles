usage() {
  echo "Usage: install [--disk DEVICE] [--mount DIR] HOST KEY_FILE" >&2
  exit 1
}

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

[ $# -eq 2 ] || usage
host=$1
key=$(realpath "$2")

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

disko_args=(--mode "destroy,format,mount" --root-mountpoint "$mnt")
if [ -n "$disk" ]; then disko_args+=(--argstr device "$disk"); fi
disko "${disko_args[@]}" "$FLAKE/hosts/$host/disko.nix"

nixos-install --root "$mnt" --flake "path:$FLAKE#$host" --no-root-passwd

bootstrap --root "$mnt" --host "$host" "$key"

echo "Installation complete, you can reboot."
