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
    ../programs/ergodox/udev-rules.nix
    ../cachix.nix
  ];

  nix = {
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
    # Load the keymap in initrd so the LUKS passphrase is typed in dvorak.
    earlySetup = true;
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
    docker.rootless = {
      enable = true;
      package = pkgs.docker_29;
      setSocketVariable = true;
    };
  };

  services.getty.autologinUser = "soywod";
  home-manager.users.soywod = import ../home.nix;
  users.users.soywod = {
    isNormalUser = true;
    extraGroups = [
      "dialout"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
    shell = pkgs.bash;
  };

  security = {
    sudo.execWheelOnly = true;
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

  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

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

  system.stateVersion = "26.05";
}
