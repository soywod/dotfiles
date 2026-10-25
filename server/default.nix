# Home server: headless, no home-manager, no user account. Root logs in over
# SSH with the GPG authentication subkey; the LUKS passphrase is typed at the
# keyboard after each boot. Serves a pruned Bitcoin node over Tor and a photo
# gallery on the local network.
{
  lib,
  pkgs,
  ...
}:

let
  photosDir = "/srv/photos";
  # The wifi network block (SSID and passphrase), kept out of the store and
  # of this public repo: the SSID locates the house in wifi maps. Copied at
  # install time, readable by wpa_supplicant only.
  wifiConfig = "/var/lib/wireless/home.conf";
  # Private ranges only: a global IPv6 address handed out by the router must
  # not expose SSH or the gallery.
  lanOnly = ports: ''
    ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport { ${ports} } accept
    ip6 saddr { fc00::/7, fe80::/10 } tcp dport { ${ports} } accept
  '';
in

{
  imports = [
    (import ./disko.nix { inherit lib; })
  ]
  ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  # GRUB rather than systemd-boot: bootctl refuses an ESP on an md array. As
  # removable, it lands in EFI/BOOT/BOOTX64.EFI of the mirrored ESP, so the
  # firmware boots either disk without any NVRAM entry.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    devices = [ "nodev" ];
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = false;
  # Assembles a degraded array after a timeout (mdadm-last-resort), and asks
  # the LUKS passphrase once.
  boot.initrd.systemd.enable = true;

  boot.swraid.mdadmConf = "PROGRAM ${pkgs.writeShellScript "md-alert" ''
    ${pkgs.util-linux}/bin/logger -p daemon.crit "mdadm: $1 on $2 $3"
    ${pkgs.util-linux}/bin/wall "mdadm: $1 on $2 $3, see the README (Server, disk failure)"
  ''}";
  # Shown at each SSH login while an array runs on one disk.
  programs.bash.interactiveShellInit = ''
    if grep -q '\[U*_U*\]' /proc/mdstat; then
      echo "WARNING: RAID degraded, see the README (Server, disk failure)" >&2
      cat /proc/mdstat >&2
    fi
  '';

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };
  services.smartd.enable = true;
  zramSwap.enable = true;

  # Same layout as the signer, loaded in initrd for the LUKS prompt. Never
  # change it afterwards: the same keystrokes would give another passphrase.
  console = {
    useXkbConfig = true;
    earlySetup = true;
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
    options = "ctrl:swapcaps";
  };
  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "server";
    wireless = {
      enable = true;
      extraConfigFiles = [ wifiConfig ];
    };
    nftables.enable = true;
    firewall.extraInputRules = lanOnly "22, 80";
  };
  # server.local on the LAN, for phones and z13.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # The console password is set by hand (passwd, see the README): mutable
  # users keep it across rebuilds.
  users.users.root = {
    # GPG authentication subkey (gpg --export-ssh-key).
    openssh.authorizedKeys.keys = [ (lib.fileContents ../ssh.pub) ];
  };
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # Pruned node, peers over Tor only, no inbound connection. RPC stays on
  # localhost with cookie authentication: btc reads the cookie as root.
  services.tor = {
    enable = true;
    client.enable = true;
  };
  services.bitcoind.main = {
    enable = true;
    prune = 2048;
    dbCache = 3000;
    extraConfig = ''
      proxy=127.0.0.1:9050
      onlynet=onion
      listen=0
    '';
  };
  systemd.services.bitcoind-main = {
    wants = [ "tor.service" ];
    after = [ "tor.service" ];
  };

  # PhotoPrism shows the photos and videos, each folder an album, to anyone
  # on the LAN (the firewall keeps it there): no login, no upload, no write
  # to the originals, no AI, no maps (they call external services). New files
  # are indexed every hour. nginx exposes it on port 80.
  systemd.tmpfiles.rules = [
    "d ${photosDir} 0755 root root -"
    "d /var/lib/wireless 0750 root wpa_supplicant -"
    "z ${wifiConfig} 0640 root wpa_supplicant -"
  ];
  services.photoprism = {
    enable = true;
    address = "127.0.0.1";
    originalsPath = photosDir;
    settings = {
      PHOTOPRISM_AUTH_MODE = "public";
      PHOTOPRISM_READONLY = "true";
      PHOTOPRISM_INDEX_SCHEDULE = "@every 1h";
      PHOTOPRISM_AUTO_INDEX = "-1";
      PHOTOPRISM_DISABLE_TENSORFLOW = "true";
      PHOTOPRISM_DISABLE_FACES = "true";
      PHOTOPRISM_DISABLE_CLASSIFICATION = "true";
      PHOTOPRISM_DISABLE_PLACES = "true";
      PHOTOPRISM_DISABLE_RAW = "true";
      PHOTOPRISM_DISABLE_WEBDAV = "true";
      PHOTOPRISM_DISABLE_SETTINGS = "true";
      PHOTOPRISM_DISABLE_BACKUPS = "true";
      PHOTOPRISM_DISABLE_OIDC = "true";
      PHOTOPRISM_SITE_URL = "http://server.local/";
      PHOTOPRISM_DEFAULT_LOCALE = "fr";
      PHOTOPRISM_DEFAULT_TIMEZONE = "Europe/Paris";
    };
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts.photos = {
      default = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2342";
        proxyWebsockets = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs._7zz
    pkgs.restic
    (pkgs.writeShellApplication {
      name = "btc";
      text = ''exec ${pkgs.bitcoind}/bin/bitcoin-cli -datadir=/var/lib/bitcoind-main "$@"'';
    })
    (pkgs.writeShellApplication {
      name = "server-backup";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.restic
        pkgs.util-linux
      ];
      runtimeEnv.PHOTOS_DIR = photosDir;
      text = builtins.readFile ./backup.sh;
    })
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.stateVersion = "26.05";
}
