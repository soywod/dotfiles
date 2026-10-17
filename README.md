# dotfiles

NixOS configurations, one per host in `hosts/`.

## Prerequisites

The GPG key is the only secret: it signs commits, decrypts the password store and, through its authentication subkey, serves as SSH key. On a machine holding the key:

```sh
gpg --quick-add-key <fingerprint> ed25519 auth
gpg --export-secret-keys --armor <fingerprint> > secret-key.asc
gpg --export-ssh-key <fingerprint>
```

Copy `secret-key.asc` to a USB stick, and add the SSH public key to GitHub.

## Install

Boot the NixOS installer, connect to the network, mount the USB stick, then:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:soywod/dotfiles#install -- [--disk DEVICE] [--mount DIR] HOST /path/to/secret-key.asc
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
nix run github:soywod/dotfiles#bootstrap -- [--root DIR] [--host HOST] /path/to/secret-key.asc
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
