{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    (import ./disko.nix { })
  ];

  networking.hostName = "z13";
}
