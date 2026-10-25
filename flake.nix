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
    himalaya = {
      url = "github:pimalaya/himalaya";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      # Workstations, one per directory in hosts/, all with home-manager.
      hosts = nixpkgs.lib.mapAttrs (name: _: host name) (
        nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );

      hostsFile = pkgs.writeText "hosts" (
        nixpkgs.lib.concatStrings (
          nixpkgs.lib.mapAttrsToList (name: host: ''
            ${name} ${host.config.home-manager.users.${user}.home.file.".mrconfig".source} ${
              host.config.environment.etc."ssh/ssh_known_hosts".source
            }
          '') hosts
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
      nixosConfigurations = hosts // {
        # Headless, no home-manager: kept out of hosts and hostsFile.
        server = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./server
          ];
        };
      };

      packages.${system} = {
        inherit bootstrap install;
        # Not a host: an image to boot, never deployed.
        signer-iso =
          (nixpkgs.lib.nixosSystem {
            modules = [
              ./iso/signer.nix
              { nixpkgs.hostPlatform = system; }
            ];
          }).config.system.build.isoImage;
        # Live installer for the server: wifi and SSH, for nixos-anywhere.
        installer-iso =
          (nixpkgs.lib.nixosSystem {
            modules = [
              ./iso/installer.nix
              { nixpkgs.hostPlatform = system; }
            ];
          }).config.system.build.isoImage;
      };

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
