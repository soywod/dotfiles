usage() {
  echo "Usage: device-hash [--size BYTES] [--expect SHA256] DEVICE" >&2
  exit 1
}

size=
expect=

while [ $# -gt 0 ]; do
  case "$1" in
    --size) size=$2; shift 2 ;;
    --expect) expect=$2; shift 2 ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -eq 1 ] || usage
device=$1

# An image written by dd is shorter than the device: hash only its size,
# the rest of the device holds whatever was there before.
if [ -n "$size" ]; then
  hash=$(head -c "$size" "$device" | sha256sum | cut -d' ' -f1)
else
  hash=$(sha256sum "$device" | cut -d' ' -f1)
fi

echo "$hash"

[ -n "$expect" ] || exit 0

if [ "$hash" = "${expect,,}" ]; then
  echo "OK: hash matches"
else
  echo "MISMATCH: expected $expect" >&2
  exit 1
fi
