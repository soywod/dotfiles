{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-master = {
      url = "github:nix-community/home-manager";
      flake = false;
    };
    himalaya.url = "github:pimalaya/himalaya";
    pimalaya-assistant.url = "github:pimalaya/assistant";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      home-manager-master,
      himalaya,
      pimalaya-assistant,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      user = "soywod";

      host =
        name:
        nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./hosts/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit
                  nixpkgs
                  home-manager-master
                  himalaya
                  pimalaya-assistant
                  ;
              };
            }
          ];
        };

      hostsFile = pkgs.writeText "hosts" (
        nixpkgs.lib.concatStrings (
          nixpkgs.lib.mapAttrsToList (name: host: ''
            ${name} ${host.config.home-manager.users.${user}.home.file.".mrconfig".source} ${
              host.config.environment.etc."ssh/ssh_known_hosts".source
            }
          '') self.nixosConfigurations
        )
      );

      bootstrap = pkgs.writeShellApplication {
        name = "bootstrap";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          git
          gnugrep
          gnupg
          hostname
          mr
          nixos-install-tools
          openssh
          pinentry-curses
        ];
        runtimeEnv = {
          HOSTS_FILE = "${hostsFile}";
          USER_NAME = user;
        };
        text = builtins.readFile ./scripts/bootstrap.sh;
      };

      install = pkgs.writeShellApplication {
        name = "install";
        runtimeInputs = [
          bootstrap
          disko.packages.${system}.disko
          pkgs.coreutils
          pkgs.nixos-install-tools
        ];
        runtimeEnv = {
          FLAKE = "${self}";
          USER_NAME = user;
        };
        text = builtins.readFile ./scripts/install.sh;
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs (name: _: host name) (
        nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );

      packages.${system} = { inherit bootstrap install; };

      apps.${system} = {
        bootstrap = {
          type = "app";
          program = "${bootstrap}/bin/bootstrap";
        };
        install = {
          type = "app";
          program = "${install}/bin/install";
        };
      };
    };
}
