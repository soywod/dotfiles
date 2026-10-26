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

## Bitcoin

Offline signer ISO, wallet and transfer cards, watch-only wallet and sending (`btc-send`, `psbt-sign`, `btc-broadcast`): [iso/README.md](iso/README.md).

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

`btc` is `bitcoin-cli` for the node (`btc getblockchaininfo`), wallets and sending are in [iso/README.md](iso/README.md). To reuse a chain copy from the same Core version or an older one, replace only `blocks/` and `chainstate/`:

```sh
systemctl stop bitcoind-main
rm -rf /var/lib/bitcoind-main/{blocks,chainstate}
cp -r /path/to/datadir/{blocks,chainstate} /var/lib/bitcoind-main/
chown -R bitcoind-main:bitcoind-main /var/lib/bitcoind-main/{blocks,chainstate}
chmod -R u=rwX,go= /var/lib/bitcoind-main/{blocks,chainstate}
systemctl start bitcoind-main
```

### Photos

Every folder of /srv/photos is an album, at <http://server.local> from the local network, behind the `admin` login. Upload from the web page, or copy albums from z13, shown at the next hourly index:

```sh
scp -r Album root@server.local:/srv/photos/
```

To index at once: `/var/lib/photoprism/photoprism-manage index`. Archives open with `7zz x archive.7z` (zip included).

After an install, set the `admin` password (kept in Bitwarden), once the service has started:

```sh
ssh -t root@server.local /var/lib/photoprism/photoprism-manage passwd admin
```

`photoprism` must have UID and GID 900. NixOS never changes the ids of an existing user: if `id photoprism` shows others, fix them by hand:

```sh
systemctl stop photoprism
groupmod -g 900 photoprism
usermod -u 900 -g 900 photoprism
systemd-tmpfiles --create
systemctl start photoprism
```

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
