{ nixpkgs, pkgs, ... }:

let
  home-manager-tarball = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  home-manager = import "${home-manager-tarball}/nixos";
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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "soywod";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
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
      font-awesome
      jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" "Font Awesome" ];
      };
    };
  };

  hardware = {
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
    extraGroups = [ "wheel" "networkmanager" "video" "docker"];
    shell = pkgs.bash;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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
