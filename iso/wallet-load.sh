usage() {
  echo "Usage: wallet-load [--check] [DEVICE]" >&2
  echo "DEVICE defaults to the filesystem labelled WALLET." >&2
  exit 1
}

check=

while [ $# -gt 0 ]; do
  case "$1" in
    --check) check=1; shift ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -le 1 ] || usage
device=${1:-/dev/disk/by-label/WALLET}
dest=/root/.bitcoin/$WALLET_NAME

[ -n "$WALLET_SHA256" ] || {
  echo "This ISO holds no reference hash: fill iso/wallet.sha256" >&2
  echo "from the offline machine, git add it, then rebuild." >&2
  exit 1
}

[ -b "$device" ] || {
  echo "No such block device: $device" >&2
  exit 1
}

# Copying over a loaded wallet would corrupt it, and cp -r into an existing
# directory nests the copy instead of replacing it.
[ -n "$check" ] || [ ! -e "$dest" ] || {
  echo "$dest already exists. To start over:" >&2
  echo "  bitcoin-cli unloadwallet $WALLET_NAME; rm -r $dest" >&2
  exit 1
}

mnt=$(mktemp -d)
mount -o ro "$device" "$mnt"
trap 'umount "$mnt"; rmdir "$mnt"' EXIT

hash=$(sha256sum "$mnt/$WALLET_NAME/wallet.dat" | cut -d' ' -f1)

if [ "$hash" != "$WALLET_SHA256" ]; then
  echo "MISMATCH: $device holds $hash" >&2
  echo "expected                $WALLET_SHA256" >&2
  exit 1
fi

echo "OK: wallet.dat matches the reference hash"
[ -z "$check" ] || exit 0

cp -r "$mnt/$WALLET_NAME" "$dest"
umount "$mnt"
rmdir "$mnt"
trap - EXIT
echo "The wallet card can leave the reader."

# Right after boot bitcoind may still be starting: wait for its RPC server.
bitcoin-cli -rpcwait -rpcwaittimeout=120 loadwallet "$WALLET_NAME"
