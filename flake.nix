{
  outputs = inputs: let
    inherit (import ./lib.nix) applyPatches mkNixOsConfigs mkHomeManagerConfigs;
    forAllSys = (import ./lib.nix).forAllSys inputs;
  in {
    nixosConfigurations = mkNixOsConfigs inputs {
      default = {
        inherit (inputs) nixpkgs;
        modules = system: {
          nix-secrets = inputs.nix-secrets.nixosModules.default;
          disko =
            (applyPatches {
              inherit (inputs.nixpkgs) lib;
              inherit (inputs) call-flake;
              pkgs = inputs.nixpkgs.legacyPackages."${system}";
              name = "disko-withTPM2";
              src = inputs.disko;
              patches = [./patches/disko/tpm2.patch];
            }).nixosModules.disko;
          nixos-hardware = inputs.hardware.nixosModules;
          preservation = inputs.preservation.nixosModules.default;
          inherit (inputs) private;
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

    homeConfigurations = mkHomeManagerConfigs inputs {
      default = {
        inherit (inputs) home-manager;
        modules = {
          nix-flatpak = inputs.nix-flatpak.homeManagerModules.nix-flatpak;
          nix-secrets = inputs.nix-secrets.homeManagerModules.default;
          inherit (inputs) private;
        };
        extra-packages = system: {
          vieb = inputs.vieb.packages."${system}".default;
          noctalia = inputs.noctalia.packages."${system}".default;
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

    packages = forAllSys (pkgs: {
      nvim = import ./home/nvim.nix {
        inherit pkgs;
        isolated = true;
      };
      fish = import ./home/fin.nix {
        inherit pkgs;
      };
    });
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
    private.url = "git+ssh://gh-joker/TheSast/dotfiles-private.git";
    nix-secrets.url = "github:unnamed-systems/nix-secrets";
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
