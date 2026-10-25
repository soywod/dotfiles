usage() {
  echo "Usage: psbt-show [--wallet NAME] FILE" >&2
  exit 1
}

cli=(bitcoin-cli)

while [ $# -gt 0 ]; do
  case "$1" in
    --wallet) cli+=("-rpcwallet=$2"); shift 2 ;;
    -h|--help) usage ;;
    *) break ;;
  esac
done

[ $# -eq 1 ] || usage

# Through stdin: a PSBT carrying full previous transactions can outgrow the
# maximum length of a command line argument.
psbt=$(tr -d '[:space:]' < "$1")
decoded=$(printf '%s\n' "$psbt" | "${cli[@]}" -stdin decodepsbt)
analyzed=$(printf '%s\n' "$psbt" | "${cli[@]}" -stdin analyzepsbt)

# Whether the loaded wallet owns an address: a change output not flagged as
# mine is the classic sign of a swapped address.
owner() {
  local info
  info=$("${cli[@]}" getaddressinfo "$1" 2>/dev/null) || {
    echo "unknown"
    return
  }
  jq -r '
    if .ischange then "change (mine)"
    elif .ismine then "mine"
    else "EXTERNAL" end
  ' <<< "$info"
}

echo "Inputs:"
jq -r '
  .tx.vin as $vin
  | .inputs | to_entries[]
  | $vin[.key] as $in
  | (.value.witness_utxo // .value.non_witness_utxo.vout[$in.vout]) as $utxo
  | "  \($in.txid):\($in.vout)  \($utxo.amount // $utxo.value // "?") BTC"
    + "  \($utxo.scriptPubKey.address // "?")"
' <<< "$decoded"

echo "Outputs:"
while IFS=$'\t' read -r n value address; do
  printf '  #%s  %s BTC  %s  %s\n' "$n" "$value" "$address" "$(owner "$address")"
done < <(jq -r '
  .tx.vout[]
  | [.n, .value, (.scriptPubKey.address // .scriptPubKey.type)]
  | @tsv
' <<< "$decoded")

jq -r '"Fee: \(.fee // "unknown") BTC"' <<< "$decoded"
jq -r '
  if .estimated_feerate then
    "Fee rate: \(.estimated_feerate * 1000000 | round / 10) sat/vB"
    + " (\(.estimated_vsize) vB)"
  else empty end,
  "Next step: \(.next)"
' <<< "$analyzed"
