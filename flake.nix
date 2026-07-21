{
  inputs = {
    # nix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    vieb = {
      url = "github:tejing1/vieb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    stdenv.hostPlatform.system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages."${stdenv.hostPlatform.system}";
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${stdenv.hostPlatform.system}";

    lib = import ./lib.nix {
      lib = inputs.nixpkgs.lib;
      inherit (inputs) call-flake;
      inherit pkgs;
    };

    pkgsForAllSystems = f:
      inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (sys: f inputs.nixpkgs.legacyPackages.${sys});

    disko-withTPM2 = lib.applyPatches {
      name = "disko-withTPM2";
      src = inputs.disko;
      patches = [./patches/disko/tpm2.patch];
    };
  in {
    nixosConfigurations = {
      kafka = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          disko-withTPM2.nixosModules.disko
          inputs.preservation.nixosModules.default
          inputs.hardware.nixosModules.framework-16-amd-ai-300-series
          ./os
          ./os/kafka
          ./os/kafka/hardware.nix
          ./os/kafka/preservation.nix
          ./os/kafka/disko.nix
        ];
        specialArgs = {inherit inputs;};
      };
      firefly = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./os
          ./os/firefly
          ./os/firefly/hardware.nix
        ];
        specialArgs = {inherit inputs;};
      };
    };

    homeConfigurations = {
      "u@kafka" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home
          ./home/kafka
        ];
        extraSpecialArgs = {inherit inputs pkgs-unstable;};
      };
      "u@firefly" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home
          ./home/firefly
        ];
        extraSpecialArgs = {inherit inputs pkgs-unstable;};
      };
    };
    formatter."${stdenv.hostPlatform.system}" = pkgs.alejandra;
    devShells = pkgsForAllSystems (pkgs: {
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
}
