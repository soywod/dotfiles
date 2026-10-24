# Offline Bitcoin signer: a live ISO with Bitcoin Core and no network stack,
# booted on an air-gapped machine to sign PSBTs. Nothing persists: the system
# runs from the boot medium and writes go to RAM.
{
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [ "${modulesPath}/installer/cd-dvd/iso-image.nix" ];

  image.baseName = lib.mkForce "signer";
  isoImage.volumeID = "SIGNER";
  # BIOS boot is on by default on x86; add the hybrid MBR so the same image
  # boots from USB as well as from DVD.
  isoImage.makeUsbBootable = true;
  # Storage drivers in initrd (SATA, PATA, USB, SD), or the boot medium is not
  # found on hardware unknown at build time.
  hardware.enableAllHardware = true;
  # Pulled in by enableAllHardware: ~900 MB of blobs, wifi and bluetooth ones
  # included, none needed on a text console.
  hardware.enableRedistributableFirmware = lib.mkForce false;

  # No network at all, even with a cable plugged in.
  networking.hostName = "signer";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.wireless.enable = false;
  networking.networkmanager.enable = false;
  hardware.bluetooth.enable = false;
  # cfg80211 takes every wifi driver down with it. Wired drivers cover the
  # usual desktop chips and USB adapters; add the one reported by lspci -k on
  # the signing machine if it is missing.
  boot.blacklistedKernelModules = [
    "cfg80211"
    "bluetooth"
    "btusb"
    "r8169"
    "forcedeth"
    "atl1"
    "atl1c"
    "atl1e"
    "e1000"
    "e1000e"
    "igb"
    "skge"
    "sky2"
    "tg3"
    "r8152"
    "cdc_ether"
    "ax88179_178a"
  ];

  environment.systemPackages = [ pkgs.bitcoind ];
  documentation.enable = false;

  console.keyMap = "dvorak";
  time.timeZone = "Europe/Paris";

  services.getty.autologinUser = "root";
  users.users.root.initialHashedPassword = "";

  system.stateVersion = "26.05";
}
