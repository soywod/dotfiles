usage() {
  echo "Usage: btc-send [OPTIONS] ADDRESS AMOUNT   pay AMOUNT BTC to ADDRESS" >&2
  echo "       btc-send [OPTIONS] --all ADDRESS    send the whole balance" >&2
  echo "       btc-send [OPTIONS] --bump TXID      raise the fee of TXID" >&2
  echo "Options:" >&2
  echo "  --fee-rate SAT_VB  defaults to the node estimate for 6 blocks" >&2
  echo "  --dir DIR          transfer card already mounted on DIR" >&2
  echo "Writes tx.psbt on the transfer card, to sign with psbt-sign." >&2
  exit 1
}

mode=pay
fee_rate=
dir=

while [ $# -gt 0 ]; do
  case "$1" in
    --all) mode=all; shift ;;
    --bump) mode=bump; shift ;;
    --fee-rate) fee_rate=$2; shift 2 ;;
    --dir) dir=$2; shift 2 ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

case $mode in
  pay) [ $# -eq 2 ] || usage ;;
  *) [ $# -eq 1 ] || usage ;;
esac

wallet=(bitcoin-cli "-rpcwallet=$WALLET_NAME")

if [ -n "$fee_rate" ]; then
  [[ $fee_rate =~ ^[0-9]+(\.[0-9]{1,3})?$ ]] || die "Invalid fee rate: $fee_rate"
elif [ $mode != bump ]; then
  # BTC/kvB to sat/vB, rounded up to the tenth. A node just started has no
  # estimate yet: psbtbumpfee makes its own, the others need one.
  fee_rate=$(bitcoin-cli estimatesmartfee 6 \
    | jq -er '.feerate // empty | . * 1000000 | ceil / 10') \
    || die "No fee estimate from the node yet: pass --fee-rate."
fi

if [ $mode != bump ]; then
  address=$1
  bitcoin-cli validateaddress "$address" | jq -e .isvalid > /dev/null \
    || die "Invalid address: $address"
fi

case $mode in
  pay)
    # As a string: jq would print a small number as 1e-08.
    [[ $2 =~ ^[0-9]+(\.[0-9]{1,8})?$ ]] || die "Invalid amount: $2"
    psbt=$("${wallet[@]}" -named walletcreatefundedpsbt \
      outputs="$(jq -nc --arg a "$address" --arg v "$2" '[{($a): $v}]')" \
      options="$(jq -nc --arg f "$fee_rate" '{fee_rate: $f, replaceable: true}')" \
      | jq -r .psbt)
    ;;
  all)
    psbt=$("${wallet[@]}" -named sendall \
      recipients="$(jq -nc --arg a "$address" '[$a]')" \
      fee_rate="$fee_rate" | jq -r .psbt)
    ;;
  bump)
    options=$(jq -nc --arg f "$fee_rate" 'if $f == "" then {} else {fee_rate: $f} end')
    psbt=$("${wallet[@]}" psbtbumpfee "$1" "$options" | jq -r .psbt)
    ;;
esac

transfer_mount rw,noexec,nosuid,nodev "$dir"
# A signed.psbt left from an earlier transaction would only confuse.
rm -f "$transfer/signed.psbt"
printf '%s\n' "$psbt" > "$transfer/tx.psbt"
psbt-show --wallet "$WALLET_NAME" "$transfer/tx.psbt"
transfer_umount
echo "tx.psbt written: sign it on the signer with psbt-sign."
