usage() {
  echo "Usage: btc-broadcast [--dir DIR]" >&2
  echo "Broadcasts signed.psbt from the transfer card, once checked against" >&2
  echo "tx.psbt. --dir: transfer card already mounted on DIR." >&2
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

transfer_mount ro,noexec,nosuid,nodev "$dir"
for f in tx.psbt signed.psbt; do
  [ -f "$transfer/$f" ] || die "No $f on the transfer card."
done

# The signer adds signatures only: any change to the transaction itself
# (outputs, amounts, fee) gives another txid.
built=$(psbt_field "$transfer/tx.psbt" .tx.txid)
signed=$(psbt_field "$transfer/signed.psbt" .tx.txid)
[ "$built" = "$signed" ] || die "signed.psbt ($signed) is not the transaction of tx.psbt ($built)."

psbt-show --wallet "$WALLET_NAME" "$transfer/signed.psbt"
final=$(tr -d '[:space:]' < "$transfer/signed.psbt" | { cat; echo; } \
  | bitcoin-cli -stdin finalizepsbt)
transfer_umount
jq -e .complete <<< "$final" > /dev/null || die "signed.psbt is not fully signed."
hex=$(jq -r .hex <<< "$final")

accept=$(jq -nc --arg h "$hex" '[$h]' | bitcoin-cli -stdin testmempoolaccept)
jq -e '.[0].allowed' <<< "$accept" > /dev/null \
  || die "Rejected by the mempool: $(jq -r '.[0]["reject-reason"]' <<< "$accept")"

confirm "Broadcast this transaction?"
printf '%s\n' "$hex" | bitcoin-cli -stdin sendrawtransaction
