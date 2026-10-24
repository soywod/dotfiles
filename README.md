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

[iso/signer.nix](iso/signer.nix) builds a live ISO for offline PSBT signing: Bitcoin Core, no network stack (wireless, bluetooth and common wired drivers blacklisted), dvorak console, root auto-login. Nothing persists: the system runs from the boot medium and writes go to RAM. It boots from BIOS, from USB or DVD, and needs no disk. The image is about 530 MB: any 1 GB stick or a DVD-R fits.

Build it (new files must be tracked by git for the flake to see them), then write down its hash:

```sh
nix build .#signer-iso
sha256sum result/iso/signer.iso
```

Write it to a stick (check the device with `lsblk`: `dd` overwrites without asking), then read it back to check the hash matches:

```sh
sudo dd if=result/iso/signer.iso of=/dev/sdX bs=4M status=progress conv=fsync
sudo head -c "$(stat -c%s result/iso/signer.iso)" /dev/sdX | sha256sum
```

The stick only ever boots the signing machine. Plug it into an online machine only to write a new image, then check the hash again.

On the signing machine, boot the stick from the BIOS boot menu, then check that `ip -br link` lists `lo` only. If a network interface shows up, run `lspci -k` to find its driver and add it to `boot.blacklistedKernelModules`.

The wallet card is mounted read-only, but `bitcoind` opens wallets read-write, so copy it to RAM first:

```sh
mount -o ro /dev/mmcblk0p1 /mnt
mkdir -p /tmp/btc/wallets
cp -r /mnt/signer /tmp/btc/wallets/
bitcoind -datadir=/tmp/btc -connect=0 -listen=0 -daemon
bitcoin-cli -datadir=/tmp/btc loadwallet signer
```

`bitcoind` needs no block: the PSBT carries the spent outputs, so `walletprocesspsbt` signs without the chain. Everything in `/tmp` is gone on shutdown.
