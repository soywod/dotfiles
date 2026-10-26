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
mount /dev/disk/by-label/WALLET /mnt && cp -r /root/.bitcoin/signer /mnt/ && umount /mnt
mount -o ro /dev/disk/by-label/WALLET /mnt && sha256sum /mnt/signer/wallet.dat && umount /mnt
```

The transfer card carries only public data (descriptors, PSBTs) between the two sides. Format it once, labelled `TRANSFER`: the scripts mount it by that label and refuse to run when two filesystems carry it.

```sh
dd if=/dev/zero of=/dev/sdX bs=4M status=progress conv=fsync
echo 'type=c' | sfdisk /dev/sdX
mkfs.vfat -F 32 -n TRANSFER /dev/sdX1
```

After the last wallet card only (`loadwallet` changes the file), export the public descriptors to the transfer card:

```sh
bitcoin-cli loadwallet signer
mount -o noexec,nosuid,nodev /dev/disk/by-label/TRANSFER /mnt
bitcoin-cli listdescriptors > /mnt/descriptors.json
umount /mnt
```

Write the hash into wallet.sha256, rebuild and rewrite the stick. Before any funds, test the restore: `wallet-load --check` every card, `wallet-load` one of them and unlock it.

## Watch-only

On the server, with a card reader dedicated to the online side:

```sh
mount -o ro,noexec,nosuid,nodev /dev/disk/by-label/TRANSFER /mnt
btc -named createwallet wallet_name=watch disable_private_keys=true blank=true load_on_startup=true
btc -rpcwallet=watch importdescriptors "$(jq -c '.descriptors | map({desc, active, internal, range, next_index, timestamp: "now"} | with_entries(select(.value != null)))' /mnt/descriptors.json)"
umount /mnt
```

`timestamp: "now"` skips the rescan, right for an empty wallet only. A pruned node cannot rescan below its prune height: re-import a funded wallet on a fresh chain, before the node syncs.

To receive, `btc -rpcwallet=watch getnewaddress`, then check it on the signer before handing it out: `bitcoin-cli getaddressinfo ADDRESS` must say `"ismine": true`.

## Sending

Three steps, the transfer card going from the server to the signer and back. Each script mounts and unmounts it by its label, `--dir DIR` uses a card already mounted on DIR instead.

1. On the server, `btc-send` builds `tx.psbt` from the watch-only wallet, change included, and shows it with `psbt-show`. The fee rate defaults to the node estimate for 6 blocks (none right after a start: pass `--fee-rate`). The transaction is replaceable.

   ```sh
   btc-send [--fee-rate SAT_VB] ADDRESS AMOUNT
   btc-send [--fee-rate SAT_VB] --all ADDRESS
   btc-send [--fee-rate SAT_VB] --bump TXID
   ```

   `--all` sends the whole balance, without change. `--bump` replaces an unconfirmed transaction with a higher fee: the new PSBT goes through the next two steps again.

2. On the signer, `wallet-load`, swap the wallet card for the transfer card, then `psbt-sign`. It shows `tx.psbt`, asks for `yes`, then for the passphrase, writes `signed.psbt` and locks the wallet again, on failure too. `psbt-show` flags each output `mine`, `change (mine)` or `EXTERNAL`: a change output shown `EXTERNAL` was swapped. Check each `EXTERNAL` address and amount against the recipient through another channel than the server, never against what the server shows. Never copy the RAM wallet back to a card.

3. On the server, `btc-broadcast` checks that `signed.psbt` holds the transaction of `tx.psbt` (same txid) and is complete, runs `testmempoolaccept`, asks for `yes`, broadcasts and prints the txid. Follow it with `btc -rpcwallet=watch gettransaction TXID`.

First send a small amount to an address of the wallet itself (`btc -rpcwallet=watch getnewaddress`): the whole cycle runs with nothing at stake, its output shown `mine`.

## Checks

Monthly: `wallet-load --check` every card, `wallet-load` one and unlock it with the passphrase typed from memory, and check the stick against the paper (online: `sudo bash iso/device-hash.sh`):

```sh
device-hash --size 550502400 --expect <sha256 from paper> /dev/sdX
```
