{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    (import ./disko.nix { })
  ];

  networking.hostName = "soywod";
}
