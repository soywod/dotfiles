# dotfiles

NixOS configurations: one per workstation in `hosts/`, the home server in `server/`.

## Prerequisites

The GPG key is the only secret: it signs commits, decrypts the password store and, through its authentication subkey, serves as SSH key. On a machine holding the key:

```sh
gpg --quick-add-key <fingerprint> ed25519 auth
gpg --export-ssh-key <fingerprint>
```

Add the SSH public key to GitHub.

## Install

Boot the NixOS installer, connect to the network, mount the USB stick, then:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:soywod/dotfiles#install -- /path/to/secret-key [--disk DEVICE] [--mount DIR] HOST
```

- `--disk`: the disk to wipe, defaults to the one declared in `hosts/HOST/disko.nix`
- `--mount`: where to mount the new system, defaults to `/mnt`

It partitions the disk (wiping it, after confirmation), asks once for a password used both as LUKS passphrase and user password, installs the system, then runs `bootstrap`. Root has no password: use `sudo`. Reboot when it is done.

For new hardware, first create `hosts/HOST/` with a `hardware-configuration.nix` generated from the installer by:

```sh
nixos-generate-config --no-filesystems --show-hardware-config
```

## Bootstrap

`bootstrap` imports the GPG key in a temporary agent (asking for its passphrase once), uses the authentication subkey to clone every repository declared in `programs.mr` over SSH, installs the key into `~/.gnupg`, then prints the keygrip of the authentication subkey.

```sh
nix run github:soywod/dotfiles#bootstrap -- [--root DIR] [--host HOST] /path/to/secret-key
```

- `--root`: root of the target system, defaults to `/` (`install` passes the mount point)
- `--host`: host whose repositories to clone, defaults to the current hostname

On first install, declare the printed keygrip in `services.gpg-agent.sshKeys` (as `"<keygrip> 0 confirm"`, to confirm each SSH use), then rebuild.

## Usage

Apply changes:

```sh
sudo nixos-rebuild switch --flake ~/.dotfiles#HOST
```

Repositories (`.dotfiles`, `.password-store`, `code/*`) are declared in `programs.mr`:

```sh
mr status     # changes and unpushed commits
mr update     # pull every repository
mr push       # push every repository
mr checkout   # clone repositories newly added to the config
```

The password store commits every change automatically. Syncing is manual: `pass git pull`, `pass git push`, or `mr update` / `mr push`. After a fresh clone, run `pass git init` once to restore decrypted diffs.

## Bitcoin signer ISO

[iso/signer.nix](iso/signer.nix) builds a live ISO for offline PSBT signing: Bitcoin Core started at boot with no peer, no network stack (wireless, bluetooth and common wired drivers blacklisted), dvorak console with caps lock and ctrl swapped, root auto-login. Nothing persists: the system runs from the boot medium and writes go to RAM. It boots from BIOS, from USB or DVD, and needs no disk. The image is about 530 MB: any 1 GB stick or a DVD-R fits.

Build it (new files must be tracked by git for the flake to see them), then write down its size and hash on paper:

```sh
nix build .#signer-iso
stat -c%s result/iso/signer.iso
sha256sum result/iso/signer.iso
```

Write it to a stick (check the device with `lsblk`: `dd` overwrites without asking), then read it back to check the hash matches:

```sh
sudo dd if=result/iso/signer.iso of=/dev/sdX bs=4M status=progress conv=fsync
sudo head -c "$(stat -c%s result/iso/signer.iso)" /dev/sdX | sha256sum
```

The stick only ever boots the signing machine. Plug it into an online machine only to write a new image, then check the hash again, ideally from a second machine: a compromised machine can write a tampered image and print the expected hash.

### Session

Boot the stick from the BIOS boot menu (it may be listed as a hard disk), then check that `ip -br link` lists `lo` only. If a network interface shows up, `ls -l /sys/class/net/*/device/driver` names its driver: add it to `boot.blacklistedKernelModules`.

`bitcoind` already runs, with `networkactive=0`, its datadir in `/root/.bitcoin` (in RAM, like everything else), so `bitcoin-cli` needs no flag. It needs no block: the PSBT carries the spent outputs, so `walletprocesspsbt` signs without the chain.

The wallet card holds the wallet `signer` in a FAT32 filesystem labelled `WALLET`. `wallet-load` mounts it read-only, checks the SHA-256 of `signer/wallet.dat` against the one built into the ISO, copies the wallet to RAM (into the datadir itself: Bitcoin Core keeps wallets there when it has no `wallets` subdirectory, and it opens them read-write), unmounts the card and loads the wallet. On a mismatch it stops before copying anything. Pass a device when the label is not enough (`lsblk`: a USB card reader shows the card as `/dev/sdX`, a built-in slot as `/dev/mmcblk0`; the boot stick is labelled `SIGNER`):

```sh
wallet-load
```

The reference hash lives in iso/wallet.sha256, one lowercase SHA-256 and nothing else (the build fails otherwise). Without the file, `wallet-load` refuses to run. It is not a secret: it is the hash of an encrypted file. Compute it on the offline machine:

```sh
mount -o ro /dev/disk/by-label/WALLET /mnt
sha256sum /mnt/signer/wallet.dat
umount /mnt
```

Copy it by hand into iso/wallet.sha256, `git add` it (the flake only sees tracked files), then rebuild the ISO. Keep a paper copy too, to check a card with a rebuilt ISO.

The wallet card is never written after its creation, so the hash holds as long as the wallet does. Never copy the RAM wallet back to the card: `loadwallet` already changed it. Once loaded, the wallet card can leave the reader for the transfer card.

Swap the wallet card for the transfer card, holding the PSBT built by the online machine, then mount it:

```sh
mount /dev/sdX1 /mnt
```

Check what the PSBT spends and pays before signing. `psbt-show` lists inputs, outputs, fee and fee rate, and flags each output as `mine`, `change (mine)` or `EXTERNAL` against the loaded wallet (pass `--wallet NAME` when several are loaded). A change output shown as `EXTERNAL` means its address was swapped. `-stdinwalletpassphrase` reads the passphrase without echo, so it stays out of the shell history:

```sh
psbt-show /mnt/tx.psbt
bitcoin-cli -stdinwalletpassphrase walletpassphrase 60
bitcoin-cli -stdin walletprocesspsbt < /mnt/tx.psbt | jq -r .psbt > /mnt/signed.psbt
psbt-show /mnt/signed.psbt
umount /mnt
```

The last `psbt-show` must end with `Next step: extractor`: the transaction is complete, the online machine finalizes and broadcasts it.

### New wallet

A descriptor wallet has no seed phrase: its only backup is `wallet.dat` plus its passphrase. Losing every card, or the passphrase, loses the funds. Keep at least two wallet cards, stored apart. A new wallet means new keys: only create one while the old one is empty, then reformat the old cards (they become the new ones).

Boot the stick and check `ip -br link` as for a session (the ISO still holding the old hash is fine: `wallet-load` is not used). Generate the passphrase on the signer (80 bits, 16 characters), write it on paper, then clear the screen:

```sh
head -c 10 /dev/urandom | base32 | tr A-Z a-z
clear
```

Create the wallet, encrypted from the start so its keys are never written in clear. `read -s` and `printf` (a builtin) keep the passphrase off the screen, the history and the process list. Then check the passphrase unlocks it:

```sh
read -rs pass
printf 'wallet_name=signer\npassphrase=%s\n' "$pass" | bitcoin-cli -named -stdin createwallet
unset pass
bitcoin-cli -stdinwalletpassphrase walletpassphrase 60
bitcoin-cli walletlock
```

Unload it (it flushes the file), check it sits in the datadir itself, and write its hash on paper:

```sh
bitcoin-cli unloadwallet signer
ls /root/.bitcoin/signer
sha256sum /root/.bitcoin/signer/wallet.dat
```

Then, for each card (`lsblk` for the device, the boot stick is labelled `SIGNER`), format it, copy the wallet, read the hash back from the card (it must match the paper), and label the card physically:

```sh
mkfs.vfat -F 32 -n WALLET /dev/sdX1
mount /dev/sdX1 /mnt
cp -r /root/.bitcoin/signer /mnt/
umount /mnt
mount -o ro /dev/sdX1 /mnt
sha256sum /mnt/signer/wallet.dat
umount /mnt
```

Copy every card before loading the wallet again: `loadwallet` changes the file in RAM. Once all cards are written, the public descriptors for the watch-only wallet can go to the transfer card in the same session (without `true`, `listdescriptors` prints no private key):

```sh
bitcoin-cli loadwallet signer
mount /dev/sdX1 /mnt
bitcoin-cli listdescriptors > /mnt/descriptors.json
umount /mnt
```

On the online machine, write the hash into iso/wallet.sha256, rebuild and rewrite the stick (see above), cross out the old hash on paper. Then test the restore from a card other than the one used daily: boot the new stick, `wallet-load --check` every card, `wallet-load` one of them and unlock it with `walletpassphrase` as in a session. Only then send funds to the wallet.

### Media checks

`wallet-load --check [DEVICE]` only checks a wallet card against the reference hash, without copying or loading anything: run it on every clone during the periodic check.

`device-hash` prints the SHA-256 of a device, or of its first `--size` bytes for an image shorter than the device, and compares it with `--expect` (exit status 1 on mismatch):

```sh
device-hash --size 550502400 --expect <sha256 from paper> /dev/sdX
```

It works the same on the online machine with `sudo bash iso/device-hash.sh`.

## Server

[server/default.nix](server/default.nix) is the home server: a pruned Bitcoin node peering over Tor only, and a PhotoPrism gallery on the local network. No desktop, no home-manager, no user account: root logs in over SSH with the GPG authentication subkey ([ssh.pub](ssh.pub)), or at the console with a password. Two NVMe in mdadm RAID1 (one array for the ESP, one for LUKS then btrfs), declared by serial in [server/disko.nix](server/disko.nix). Wifi only: the network block (SSID and passphrase) lives in /var/lib/wireless/home.conf, outside the store and this repository, since the SSID alone locates the house in wifi maps.

### Install

Build the installer ISO ([iso/installer.nix](iso/installer.nix): the NixOS minimal installer with the console of the signer, nmtui for wifi, SSH open to the authentication subkey), then write it like the signer ISO, by stable device path:

```sh
nix build .#installer-iso
sudo dd if=result/iso/installer.iso of=/dev/disk/by-id/usb-... bs=4M conv=fsync status=progress
```

Boot it on the server from the firmware boot menu (its UEFI entry), run `nmtui` to join the wifi, and note the address with `ip -br addr`. From z13, prepare both secrets in RAM:

```sh
d=$(mktemp -d -p "$XDG_RUNTIME_DIR")
mkdir -p "$d/files/var/lib/wireless"
read -rsp 'Wifi passphrase: ' w; echo
printf 'network={\n  ssid="SSID"\n  psk="%s"\n  key_mgmt=SAE WPA-PSK\n  ieee80211w=1\n}\n' "$w" > "$d/files/var/lib/wireless/home.conf"
read -rsp 'LUKS passphrase: ' l; echo
printf '%s' "$l" > "$d/luks.key"
unset w l
```

Then install. It wipes both NVMe without asking, and nothing else:

```sh
nix run --inputs-from . nixpkgs#nixos-anywhere -- \
  --flake .#server \
  --target-host root@IP \
  --build-on local \
  --generate-hardware-config nixos-generate-config ./server/hardware-configuration.nix \
  --disk-encryption-keys /tmp/secret.key "$d/luks.key" \
  --extra-files "$d/files"
```

The server reboots when it is done. Remove the stick, unlock, then from z13 forget the installer host key, set the console password and drop the secrets:

```sh
ssh-keygen -R IP
ssh root@server.local passwd
rm -rf "$d"
```

The console password survives rebuilds (users are mutable) but not a reinstall: run `passwd` again after each one. SSH never accepts it.

### Unlock

After each boot, type the LUKS passphrase at the keyboard plugged into the server, in the layout of the signer (dvorak, caps lock and ctrl swapped). One prompt unlocks the system, even with a disk missing. Without it the server stays offline: there is no remote unlock.

### Deploy

From z13, built locally then copied over SSH (new files must be tracked by git for the flake to see them):

```sh
nixos-rebuild switch --flake ~/.dotfiles#server --target-host root@server.local
```

A kernel update needs a reboot, so someone at the keyboard.

### Bitcoin

`btc` runs `bitcoin-cli` against the node, no flag needed:

```sh
btc getblockchaininfo
```

To reuse a copy of the chain instead of syncing from scratch, stop the node, replace `blocks/` and `chainstate/` (never `settings.json` nor old wallets), fix ownership, start it again:

```sh
systemctl stop bitcoind-main
rm -rf /var/lib/bitcoind-main/{blocks,chainstate}
cp -r /path/to/datadir/{blocks,chainstate} /var/lib/bitcoind-main/
chown -R bitcoind-main:bitcoind-main /var/lib/bitcoind-main/{blocks,chainstate}
chmod -R u=rwX,go= /var/lib/bitcoind-main/{blocks,chainstate}
systemctl start bitcoind-main
```

The copy must come from the same Bitcoin Core version or an older one, and the node keeps `prune = 2048`: disabling pruning means a full resync.

### Photos

Every folder of /srv/photos is an album, browsable by anyone on the local network at <http://server.local>: no account, read only. Copy new albums from z13, they show up at the next hourly index:

```sh
scp -r Album root@server.local:/srv/photos/
```

To index at once: `/var/lib/photoprism/photoprism-manage index`. Archives open with `7zz x archive.7z` (zip included).

### Backup

The photos are the only data to back up: the PhotoPrism index rebuilds from them, the watch-only wallet re-imports from the signer, the chain downloads again. Backups go to an external disk with restic (encrypted, password kept in pass). Format the disk once with a label, then initialise its repository on the first run:

```sh
mkfs.ext4 -L BACKUP1 /dev/sdX1
server-backup --init BACKUP1
```

Then, each time, plug the disk and run `server-backup BACKUP1`: it mounts the disk, backs up /srv/photos, checks the repository, unmounts. To restore, mount the disk (`mount /dev/disk/by-label/BACKUP1 /mnt`) and run `restic -r /mnt/restic restore latest --target /`.

### Disk failure

A lost disk prints a `wall` message on the console (`mdadm: Fail ...` or `DegradedArray`), and every SSH login warns while an array runs on one disk. `Rebuild20` to `Rebuild80` and `RebuildFinished` only report resync progress. Check the state:

```sh
cat /proc/mdstat
mdadm --detail /dev/md/root
```

`[UU]` is healthy, `[U_]` or `[_U]` runs on one disk. Identify the dead one by serial with `ls -l /dev/disk/by-id/ | grep nvme`: kernel names (`nvme0n1`) do not match disko names (`disk-nvme0-*`).

1. Power off, replace the dead disk, boot. The arrays start degraded after a short wait; unlock as usual. If the firmware does not boot, pick the remaining disk in its boot menu.
2. Copy the partition table of the healthy disk onto the new one, then give the copy its own GUIDs (`GOOD` and `NEW` are /dev/disk/by-id paths, double check the order: the first one is overwritten):

   ```sh
   nix shell nixpkgs#gptfdisk -c sgdisk --replicate=NEW GOOD
   nix shell nixpkgs#gptfdisk -c sgdisk --randomize-guids NEW
   ```

3. Add both partitions to their arrays:

   ```sh
   mdadm /dev/md/boot --add NEW-part1
   mdadm /dev/md/root --add NEW-part2
   ```

4. Wait for `[UU]` in `cat /proc/mdstat` (about 40 minutes). Nothing else to do: LUKS and btrfs sit above the arrays, GRUB comes back with the ESP, and the disk paths in server/disko.nix only matter when formatting.

Not tested yet on the real hardware: update this section after the first drill.
