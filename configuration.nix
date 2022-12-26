{ nixpkgs, pkgs, lib, ... }:

let
  # home-manager-tarball = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  # home-manager = import "${home-manager-tarball}/nixos";
  home-manager = import /home/soywod/code/home-manager/nixos;
  font-awesome = pkgs.fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    rev = "6.1.1";
    sha256 = "BjK1PJQFWtKDvfQ2Vh7BoOPqYucyvOG+2Pu/Kh+JpAA=";
    postFetch = ''
      tar xf $downloadedFile --strip=1
      install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./programs/ergodox/udev-rules.nix
    home-manager
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576;
      "fs.inotify.max_user_instances" = 1024;
      "fs.inotify.max_queued_events" = 32768;
    };
  };

  networking = {
    hostName = "soywod";
    networkmanager.enable = true;
    useDHCP = false;
    # interfaces.wlp0s20f3.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" ];
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "fr_FR.UTF-8";
      LC_CTYPE = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_COLLATE = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
    };
  };

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "dvorak";
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
    ] ++ [
      font-awesome
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" "Font Awesome" ];
      };
    };
  };

  sound = {
    enable = false;
  };

  hardware = {
    pulseaudio = {
      enable = false;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    opengl = {
      enable = true;
    };
  };

  virtualisation.docker.enable = true;

  services.getty.autologinUser = "soywod";
  home-manager.users.soywod = import ./home.nix;
  users.users.soywod = {
    isNormalUser = true;
    hashedPassword = "$6$LMKJHJSxnGOwEwuF$KJQLQcOkXlHWkGWp7Z4/eXetRoVnuiSOv2Rl6BNtEhpgpX2b/Ky5ELHYL3Q0kQbERSKiMWfEmDXLAOX6fAivg0";
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.bash;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  services.geoclue2 = {
    enable = true;
  };

  system.stateVersion = "21.05";
}
