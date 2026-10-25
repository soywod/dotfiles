# dotfiles

NixOS configurations, one per host in `hosts/`.

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

### Media checks

`wallet-load --check [DEVICE]` only checks a wallet card against the reference hash, without copying or loading anything: run it on every clone during the periodic check.

`device-hash` prints the SHA-256 of a device, or of its first `--size` bytes for an image shorter than the device, and compares it with `--expect` (exit status 1 on mismatch):

```sh
device-hash --size 550502400 --expect <sha256 from paper> /dev/sdX
```

It works the same on the online machine with `sudo bash iso/device-hash.sh`.
