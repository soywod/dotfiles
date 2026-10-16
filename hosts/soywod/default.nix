{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "soywod";
}
