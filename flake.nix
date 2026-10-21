{
  outputs = inputs: let
    lib = import ./lib.nix;
    forAllSys = lib.forAllSys inputs;
  in {
    nixosConfigurations = lib.mkNixOsConfigs inputs {
      default = {
        inherit (inputs) nixpkgs;
        modules = system: {
          agenix = inputs.agenix.nixosModules.default;
          disko =
            (lib.applyPatches {
              lib = inputs.nixpkgs.lib;
              inherit (inputs) call-flake;
              pkgs = inputs.nixpkgs.legacyPackages."${system}";
              name = "disko-withTPM2";
              src = inputs.disko;
              patches = [./patches/disko/tpm2.patch];
            }).nixosModules.disko;
          nixos-hardware = inputs.hardware.nixosModules;
          preservation = inputs.preservation.nixosModules.default;
        };
      };
      kafka = {
        system = "x86_64-linux";
      };
      firefly = {
        nixpkgs = inputs.nixpkgs-unstable;
        system = "x86_64-linux";
        modules = {
          jovian = inputs.jovian.nixosModules.default;
        };
      };
    };

    homeConfigurations = lib.mkHomeManagerConfigs inputs {
      default = {
        inherit (inputs) home-manager;
        modules = {
          nix-flatpak = inputs.nix-flatpak.homeManagerModules.nix-flatpak;
          agenix = inputs.agenix.homeManagerModules.default;
        };
        extra-packages = system: {
          vieb = inputs.vieb.packages."${system}".default;
          noctalia = inputs.noctalia.packages."${system}".default;
          ragenix = inputs.ragenix.packages."${system}".default;
        };
      };
      "u@kafka" = {
        system = "x86_64-linux";
      };
      "u@firefly" = {
        home-manager = inputs.home-manager-unstable;
        system = "x86_64-linux";
        modules = {
          steam-config-nix = inputs.steam-config-nix.homeModules.default;
        };
        extra-packages = system: {
          noctalia = inputs.noctalia-unstable.packages."${system}".default;
        };
      };
    };

    formatter = forAllSys (pkgs: pkgs.alejandra);
    devShells = forAllSys (pkgs: {
      shell =
        pkgs.mkShell.override
        {
          stdenv = pkgs.stdenvNoCC;
        }
        {
          packages = with pkgs; [
            shellcheck
            bash-language-server
            shellharden
            shfmt
          ];
        };
    });
  };

  inputs = {
    # nix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    call-flake.url = "github:divnix/call-flake";

    # shared
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # system
    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # user
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-unstable = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vieb = {
      url = "github:tejing1/vieb-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
