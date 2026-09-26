# Jitsi Meet host for meet.pimalaya.org. See README.md for the bootstrap.
{ lib, ... }:
{
  # Boot via BIOS/GRUB (matches disko.nix). For a UEFI VPS, use the ESP in
  # disko.nix and switch this block to systemd-boot.
  boot.loader.grub = {
    enable = true;
  };
  # Common virtio modules so a KVM VPS finds its disk in early boot.
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ahci"
    "sd_mod"
  ];

  # Networking: most cloud VPS use DHCP; set a static IP explicitly if given one.
  networking.hostName = "meetbox";
  networking.useDHCP = lib.mkDefault true;

  # SSH: your key, or you lock yourself out of the freshly installed box.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfprZaEimOW4D7XT6/HeyPpbaXD+wNDY8JFkXFkBA03 soywod@soywod"
  ];

  # nixpkgs flags jitsi-meet because it bundles libolm (deprecated crypto lib)
  # for the OPTIONAL in-browser E2EE feature, which we don't rely on —
  # transport is TLS/DTLS-SRTP regardless. Pinned to the exact version so a
  # nixpkgs bump resurfaces the question instead of silently re-accepting.
  nixpkgs.config.permittedInsecurePackages = [ "jitsi-meet-1.0.8792" ];

  services.jitsi-meet = {
    enable = true;
    hostName = "meet.pimalaya.org";

    # Room CREATION requires a Prosody account (register one on the box, see
    # README); guests then join existing rooms through the shared link without
    # any account. Without this, anyone on the internet can host rooms on your
    # server and burn its bandwidth.
    secureDomain.enable = true;

    # Prosody here is a Jitsi companion only: loopback, no TLS termination,
    # no federation.
    prosody.lockdown = true;

    config = {
      # 1:1 calls flow peer-to-peer and never touch the videobridge.
      p2p.enabled = true;
      # Nudge bandwidth down: fine for small meetings on a modest VPS.
      resolution = 720;
    };
  };

  # The jitsi-meet module already sets enableACME + forceSSL on its nginx
  # vhost; this is the account side Let's Encrypt requires.
  security.acme = {
    acceptTerms = true;
    defaults.email = "clement.douin@posteo.net";
  };

  # Opens 10000/UDP (RTP media) + the videobridge TCP fallback.
  services.jitsi-videobridge.openFirewall = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "25.11";
}
