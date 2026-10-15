{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pimalaya-assistant.url = "github:pimalaya/assistant";
  };

  outputs =
    { nixpkgs, home-manager, pimalaya-assistant, ... }:
    let
      host =
        name:
        nixpkgs.lib.nixosSystem {
          modules = [
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
