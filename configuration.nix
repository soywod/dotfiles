{
  pkgs,
  config,
  ...
}:

let
  font-awesome = pkgs.fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    rev = "6.1.1";
    sha256 = "BjK1PJQFWtKDvfQ2Vh7BoOPqYucyvOG+2Pu/Kh+JpAA=";
    postFetch = ''
      src=$(mktemp -d)
      mv "$out"/* "$src"/
      install -m444 -Dt "$out/share/fonts/opentype" "$src"/{fonts,otfs}/*.otf
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./programs/ergodox/udev-rules.nix
    ./cachix.nix
    <home-manager/nixos>
  ];

  services.bitcoind.main = {
    enable = true;
    prune = 2048;
    dbCache = 3000;
    group = "bitcoin";
    user = "bitcoin";
    extraConfig = ''
      server=1
      rpcallowip=127.0.0.1
    '';
  };

  nix = {
    settings.trusted-users = [
      "root"
      "soywod"
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # environment.etc = {
  #   "pipewire/pipewire.conf.d/combine-sink.conf".text = ''
  #     context.exec = [
  #       { path = "pactl" args = "load-module module-combine-sink" }
  #     ]
  #   '';
  # };

  boot = {
    enableContainers = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576;
      "fs.inotify.max_user_instances" = 1024;
      "fs.inotify.max_queued_events" = 32768;
    };

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  services.avahi.enable = true;
  services.resolved.enable = true;
  networking = {
    hostName = "soywod";
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    networkmanager = {
      enable = true;
      connectionConfig."connection.mdns" = 2;
    };
  };

  time.timeZone = "Europe/Paris";

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "dvorak";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      jetbrains-mono
      font-awesome
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [
          "JetBrains Mono"
          "Font Awesome"
        ];
      };
    };
  };

  services.pulseaudio.enable = false;

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    graphics = {
      enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker_29;
    };
  };

  services.getty.autologinUser = "soywod";
  home-manager.users.soywod = import ./home.nix;
  users.users.soywod = {
    isNormalUser = true;
    extraGroups = [
      "bitcoin"
      "dialout"
      "docker"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
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

  services.fwupd = {
    enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "25.11";
}
