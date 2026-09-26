# meet.pimalaya.org — Jitsi Meet deploy

Same pattern as carillon's `deploy/`: a self-contained flake installed remotely
with nixos-anywhere onto a fresh OVH VPS.

> **WARNING**: nixos-anywhere REPARTITIONS AND WIPES the target disk. Only
> point it at a VPS whose content you are willing to lose. In particular, do
> NOT run it against the box already running carillon (`watchbox`) — to host
> both on one machine, merge this `configuration.nix` into watchbox's config
> instead.

## Bootstrap

1. DNS: add an `A` record `meet.pimalaya.org` → the VPS public IP (Let's
   Encrypt needs it resolving before the first activation).

2. Confirm the disk layout assumptions against the VPS rescue/initial system:

   ```sh
   ssh root@<vps-ip> lsblk
   ssh root@<vps-ip> '[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS'
   ```

   Adjust `disko.nix` (device, BIOS vs UEFI) if it disagrees.

3. Install:

   ```sh
   nix run github:nix-community/nixos-anywhere -- --flake .#meetbox root@<vps-ip>
   ```

4. Create the account allowed to HOST meetings (`secureDomain` is enabled, so
   room creation is authenticated; guests join via link, no account needed):

   ```sh
   ssh root@meet.pimalaya.org prosodyctl register clement meet.pimalaya.org '<password>'
   ```

   When starting a meeting, log in as `clement` when prompted ("I am the host").

## Day 2

- Redeploy config changes (no reinstall):

  ```sh
  nixos-rebuild switch --flake .#meetbox --target-host root@meet.pimalaya.org
  ```

- Jitsi's internal component secrets are generated on the box at first boot
  (`/var/lib/jitsi-meet/`); nothing secret lives in this repo, so no sops
  layer is needed here.
