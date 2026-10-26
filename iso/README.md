# Bitcoin

Cold storage on two machines: [signer.nix](signer.nix) is a live ISO that signs PSBTs offline, the [server](../server) runs the node and a watch-only wallet that builds and broadcasts them. Check `lsblk` before every `dd`, `mkfs` or `mount`: the stick is labelled `SIGNER`, the wallet cards `WALLET`.

## Signer ISO

Bitcoin Core with no network stack (every network, wifi, bluetooth and USB modem driver of the kernel refused, in initrd too), dvorak console with caps lock and ctrl swapped, root auto-login. It runs from the stick, writes go to RAM. Build it, write its size and hash on paper, then write and read back the stick:

```sh
nix build .#signer-iso
stat -c%s result/iso/signer.iso
sha256sum result/iso/signer.iso
sudo dd if=result/iso/signer.iso of=/dev/sdX bs=4M status=progress conv=fsync
sudo head -c "$(stat -c%s result/iso/signer.iso)" /dev/sdX | sha256sum
```

The stick touches an online machine only to be rewritten, then its hash is checked again (ideally from a second machine). At each boot, `ip -br link` must list `lo` only: otherwise `ls -l /sys/class/net/*/device/driver` names a driver outside the directories blocked in signer.nix.

## Wallet

A descriptor wallet has no seed phrase: its backup is `wallet.dat`, on three cards hidden apart, plus its passphrase, on paper and never next to a card. Cards are written once. [wallet.sha256](wallet.sha256) holds the hash of `wallet.dat` that `wallet-load` checks.

Create it on the signer, only while the previous wallet is empty. The passphrase and the hash go on paper:

```sh
head -c 10 /dev/urandom | base32 | tr A-Z a-z
clear
read -rs pass
printf 'wallet_name=signer\npassphrase=%s\n' "$pass" | bitcoin-cli -named -stdin createwallet
unset pass
bitcoin-cli -stdinwalletpassphrase walletpassphrase 60
bitcoin-cli unloadwallet signer
sha256sum /root/.bitcoin/signer/wallet.dat
```

Then for each card, the last hash must match the paper:

```sh
dd if=/dev/zero of=/dev/sdX bs=4M status=progress conv=fsync
echo 'type=c' | sfdisk /dev/sdX
mkfs.vfat -F 32 -n WALLET /dev/sdX1
mount /dev/sdX1 /mnt && cp -r /root/.bitcoin/signer /mnt/ && umount /mnt
mount -o ro /dev/sdX1 /mnt && sha256sum /mnt/signer/wallet.dat && umount /mnt
```

After the last card only (`loadwallet` changes the file), export the public descriptors to the transfer card:

```sh
bitcoin-cli loadwallet signer
mount /dev/sdX1 /mnt
bitcoin-cli listdescriptors > /mnt/descriptors.json
umount /mnt
```

Write the hash into wallet.sha256, rebuild and rewrite the stick. Before any funds, test the restore: `wallet-load --check` every card, `wallet-load` one of them and unlock it.

## Watch-only

On the server, with a card reader dedicated to the online side:

```sh
mount -o ro,noexec,nosuid,nodev /dev/sdX1 /mnt
btc -named createwallet wallet_name=watch disable_private_keys=true blank=true load_on_startup=true
btc -rpcwallet=watch importdescriptors "$(jq -c '.descriptors | map({desc, active, internal, range, next_index, timestamp: "now"} | with_entries(select(.value != null)))' /mnt/descriptors.json)"
umount /mnt
```

`timestamp: "now"` skips the rescan, right for an empty wallet only. A pruned node cannot rescan below its prune height: re-import a funded wallet on a fresh chain, before the node syncs.

To receive, `btc -rpcwallet=watch getnewaddress`, then check it on the signer before handing it out: `bitcoin-cli getaddressinfo ADDRESS` must say `"ismine": true`.

## Signing

The online side writes only `tx.psbt` on the transfer card. On the signer, load the wallet, swap its card for the transfer card, then:

```sh
wallet-load
mount -o noexec,nosuid,nodev /dev/sdX1 /mnt
psbt-show /mnt/tx.psbt
bitcoin-cli -stdinwalletpassphrase walletpassphrase 60
bitcoin-cli -stdin walletprocesspsbt < /mnt/tx.psbt | jq -r .psbt > /mnt/signed.psbt
psbt-show /mnt/signed.psbt
umount /mnt
```

`psbt-show` flags each output `mine`, `change (mine)` or `EXTERNAL`: a change output shown `EXTERNAL` was swapped. The second one must end with `Next step: extractor`. Never copy the RAM wallet back to a card.

## Checks

Monthly: `wallet-load --check` every card, `wallet-load` one and unlock it with the passphrase typed from memory, and check the stick against the paper (online: `sudo bash iso/device-hash.sh`):

```sh
device-hash --size 550502400 --expect <sha256 from paper> /dev/sdX
```
