{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pimalaya-assistant.url = "github:pimalaya/assistant";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, pimalaya-assistant, disko, ... }:
    let
      host =
        name:
        nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit nixpkgs pimalaya-assistant; };
            }
          ];
        };
    in
    {
      nixosConfigurations.soywod = host "soywod";
    };
}
