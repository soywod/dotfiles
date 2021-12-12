{ nixpkgs, pkgs, ... }:

let
  home-manager-tarball = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  home-manager = import "${home-manager-tarball}/nixos";
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
    
  imports = [
    ./hardware-configuration.nix
    ./programs/ergodox/udev-rules.nix
    home-manager
  ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        monospace = ["JetBrains Mono" "Font Awesome"];
      };
    };
  };
  
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl = {
    enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.soywod = {
    isNormalUser = true;
    hashedPassword = "$6$LMKJHJSxnGOwEwuF$KJQLQcOkXlHWkGWp7Z4/eXetRoVnuiSOv2Rl6BNtEhpgpX2b/Ky5ELHYL3Q0kQbERSKiMWfEmDXLAOX6fAivg0";
    extraGroups = ["wheel" "networkmanager" "video"];
    shell = pkgs.bash;
  };
  security.sudo.wheelNeedsPassword = false;
  home-manager.users.soywod = import ./home.nix;

  services.getty.autologinUser = "soywod";

  system.stateVersion = "21.05";
}
