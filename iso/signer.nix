# Offline Bitcoin signer: a live ISO with Bitcoin Core and no network stack,
# booted on an air-gapped machine to sign PSBTs. Nothing persists: the system
# runs from the boot medium and writes go to RAM.
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

let
  walletName = "signer";
  # SHA-256 of wallet.dat on the wallet card, copied by hand from the offline
  # machine. Without it, wallet-load refuses to run.
  walletSha256 =
    if builtins.pathExists ./wallet.sha256 then lib.fileContents ./wallet.sha256 else "";
  # drivers/net holds wired, wifi, USB (phone tethering, LTE modems) and
  # virtual NICs; staging holds more wifi; usb/serial the modem tty drivers.
  # The build fails if a known driver is missing, i.e. the layout changed.
  noNet =
    pkgs.runCommand "no-net.conf" { modules = config.boot.kernelPackages.kernel.modules; }
      ''
        cd $modules/lib/modules/*/kernel
        find drivers/net drivers/staging drivers/bluetooth drivers/nfc \
          drivers/firewire drivers/usb/serial net/wireless net/mac80211 \
          net/bluetooth net/nfc net/ieee802154 net/6lowpan -name '*.ko*' \
          | sed -E 's|.*/||; s|\.ko(\.[a-z]+)?$||; s|-|_|g' | sort -u \
          | sed 's|.*|install & exit 1|' > $out
        for m in e1000e igc r8169 iwlwifi cfg80211 btusb virtio_net rndis_host \
          cdc_ether cdc_ncm ipheth qmi_wwan cdc_mbim option firewire_net; do
          grep -q "^install $m " $out || { echo "no-net: $m missing" >&2; exit 1; }
        done
      '';
in

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
  # Every network, wifi, bluetooth, NFC and USB modem driver of the kernel
  # refuses to load, explicit modprobe and dependencies included (blacklist
  # only stops udev). Generated from the module tree, so new drivers are
  # covered without a hand-kept list.
  environment.etc."modprobe.d/no-net.conf".source = noNet;
  # In initrd too: it holds virtio_net and vmxnet3 among its storage drivers.
  boot.initrd.systemd.contents."/etc/modprobe.d/no-net.conf".source = noNet;

  environment.systemPackages = [
    pkgs.bitcoind
    pkgs.jq
    (pkgs.writeShellApplication {
      name = "device-hash";
      runtimeInputs = [ pkgs.coreutils ];
      text = builtins.readFile ./device-hash.sh;
    })
    (pkgs.writeShellApplication {
      name = "psbt-show";
      runtimeInputs = [
        pkgs.bitcoind
        pkgs.coreutils
        pkgs.jq
      ];
      text = builtins.readFile ./psbt-show.sh;
    })
    (pkgs.writeShellApplication {
      name = "wallet-load";
      runtimeInputs = [
        pkgs.bitcoind
        pkgs.coreutils
        pkgs.util-linux
      ];
      runtimeEnv = {
        WALLET_NAME = walletName;
        WALLET_SHA256 = walletSha256;
      };
      text = builtins.readFile ./wallet-load.sh;
    })
  ];
  documentation.enable = false;

  # A hand-copied hash: catch a dropped or extra character at build time.
  assertions = [
    {
      assertion = walletSha256 == "" || builtins.match "[0-9a-f]{64}" walletSha256 != null;
      message = "iso/wallet.sha256 must hold one lowercase SHA-256 (64 hex digits), nothing else.";
    }
  ];

  # Bitcoin Core with no peer: the signer never syncs, the PSBT carries the
  # spent outputs signing needs. The datadir is the default one of root, so
  # bitcoin-cli needs no flag; like the rest of the system it lives in RAM.
  systemd.tmpfiles.rules = [
    # Mount point for the cards, missing from a bare live system.
    "d /mnt 0755 root root -"
    "d /root/.bitcoin 0700 root root -"
    "L+ /root/.bitcoin/bitcoin.conf - - - - ${pkgs.writeText "bitcoin.conf" ''
      networkactive=0
      connect=0
      listen=0
      dnsseed=0
      fixedseeds=0
    ''}"
  ];
  systemd.services.bitcoind = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.bitcoind}/bin/bitcoind -datadir=/root/.bitcoin";
  };

  # Console keymap generated from these xkb settings at build time, X itself
  # stays off.
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
    options = "ctrl:swapcaps";
  };
  time.timeZone = "Europe/Paris";

  services.getty.autologinUser = "root";
  users.users.root.initialHashedPassword = "";

  system.stateVersion = "26.05";
}
