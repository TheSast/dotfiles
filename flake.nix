{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nfsm = {
      url = "github:gvolpe/nfsm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vieb = {
      url = "github:tejing1/vieb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    stdenv.hostPlatform.system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${stdenv.hostPlatform.system}";
    pkgs-unstable = nixpkgs-unstable.legacyPackages."${stdenv.hostPlatform.system}";
    pkgsForAllSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: f nixpkgs.legacyPackages.${system});
  in {
    nixosConfigurations = {
      kafka = nixpkgs.lib.nixosSystem {
        modules = [
          ./os
          ./os/kafka
          ./os/kafka/hardware.nix
        ];
        specialArgs = {inherit inputs;};
      };
      firefly = nixpkgs.lib.nixosSystem {
        modules = [
          ./os
          ./os/firefly
          ./os/firefly/hardware.nix
        ];
        specialArgs = {inherit inputs;};
      };
    };

    homeConfigurations = {
      "u@kafka" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home
          ./home/kafka
        ];
        extraSpecialArgs = {inherit inputs pkgs-unstable;};
      };
      "u@firefly" = home-manager.lib.homeManagerConfiguration {
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
        pkgs.mkShell.override {
          stdenv = pkgs.stdenvNoCC;
        } {
          packages = with pkgs; [
            shellcheck
            bash-language-server
            shellharden
            shfmt
          ];
        };
      hypr =
        pkgs.mkShell.override {
          stdenv = pkgs.stdenvNoCC;
        } {
          packages = with pkgs; [
            hyprls
          ];
        };
    });
  };
}
