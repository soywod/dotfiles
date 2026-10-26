usage() {
  echo "Usage: psbt-sign [--dir DIR]" >&2
  echo "Signs tx.psbt from the transfer card into signed.psbt, with the" >&2
  echo "wallet loaded by wallet-load. --dir: card already mounted on DIR." >&2
  exit 1
}

dir=

while [ $# -gt 0 ]; do
  case "$1" in
    --dir) dir=$2; shift 2 ;;
    -h|--help) usage ;;
    *) usage ;;
  esac
done

bitcoin-cli listwallets | jq -e --arg w "$WALLET_NAME" 'index($w)' > /dev/null \
  || die "Wallet $WALLET_NAME not loaded: run wallet-load first."

transfer_mount rw,noexec,nosuid,nodev "$dir"
[ -f "$transfer/tx.psbt" ] || die "No tx.psbt on the transfer card."
rm -f "$transfer/signed.psbt"

psbt-show "$transfer/tx.psbt"
echo "Check each EXTERNAL address against the recipient, through another" \
  "channel than the server."
confirm "Sign this transaction?"

# Locked again as soon as signed, or on any failure.
trap 'bitcoin-cli walletlock; transfer_umount' EXIT
bitcoin-cli -stdinwalletpassphrase walletpassphrase 60
signed=$(tr -d '[:space:]' < "$transfer/tx.psbt" | { cat; echo; } \
  | bitcoin-cli -stdin walletprocesspsbt)
bitcoin-cli walletlock
trap transfer_umount EXIT

jq -e .complete <<< "$signed" > /dev/null \
  || die "Not fully signed: an input belongs to another wallet."
jq -r .psbt <<< "$signed" > "$transfer/signed.psbt"
echo
psbt-show "$transfer/signed.psbt"
transfer_umount
echo "signed.psbt written: broadcast it on the server with btc-broadcast."
