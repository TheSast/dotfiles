let
  setOrSystemFn = system: x:
    if builtins.isNull x
    then {}
    else if builtins.isFunction x
    then x system
    else x;
in {
  applyPatches = {
    lib,
    pkgs,
    call-flake,
    name,
    src,
    patches,
    # patches = [
    #   ./my-fix.patch
    #   {
    #     url = "https://example.com/fix.patch";
    #     hash = "sha256-...";
    #   }
    # ];
    lockFileEntries ? {},
  }: let
    patched =
      (pkgs.applyPatches {
        inherit name src;
        patches = map (patch:
          if lib.isPath patch
          then patch
          else pkgs.fetchpatch2 patch)
        patches;
      }).overrideAttrs
      (
        _: prevAttrs: {
          outputs = [
            "out"
            "narHash"
          ];
          installPhase = lib.concatStringsSep "\n" [
            prevAttrs.installPhase
            ''
              ${lib.getExe pkgs.nix} \
                --extra-experimental-features nix-command \
                --offline \
                hash path ./ \
                > $narHash
            ''
          ];
        }
      );

    lockFilePath = "${patched.outPath}/flake.lock";
    lockFile = builtins.unsafeDiscardStringContext (
      lib.generators.toJSON {} (
        if lib.pathExists lockFilePath
        then let
          original = lib.importJSON lockFilePath;
        in {
          inherit (original) root;
          nodes = lib.recursiveUpdate original.nodes lockFileEntries;
        }
        else {
          nodes.root.inputs = {};
          root = "root";
          version = 7;
        }
      )
    );
  in
    (import "${call-flake}/call-flake.nix") lockFile {
      root = {
        sourceInfo = {
          inherit (patched) outPath;
        };
        subdir = "";
      };
    };

  forAllSys = inputs: f:
    inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (sys: f inputs.nixpkgs.legacyPackages.${sys});

  mkNixOsConfigs = inputs: cfg: (builtins.mapAttrs (
    host: {
      nixpkgs ? cfg.default.nixpkgs,
      system,
      modules ? {},
      extra-packages ? {},
    }:
      nixpkgs.lib.nixosSystem {
        modules = [
          ./os
          ./os/hosts/${host}
          {networking.hostName = host;}
        ];
        specialArgs = {
          modules = (setOrSystemFn system cfg.default.modules) // (setOrSystemFn system modules);
          flake = inputs.self;
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
          pkgs-extra =
            (setOrSystemFn system cfg.default.extra-packages) // (setOrSystemFn system extra-packages);
        };
      }
  ) (builtins.removeAttrs cfg ["default"]));

  mkHomeManagerConfigs = inputs: cfg: (builtins.mapAttrs (
    host: {
      home-manager ? cfg.default.home-manager,
      system,
      modules ? {},
      extra-packages ? {},
    }: let
      pkgs = home-manager.inputs.nixpkgs.legacyPackages."${system}";
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home
          ./home/hosts/${pkgs.lib.last (pkgs.lib.splitString "@" host)}
        ];
        extraSpecialArgs = {
          modules = (setOrSystemFn system cfg.default.modules) // (setOrSystemFn system modules);
          flake = inputs.self;
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."${system}";
          pkgs-extra =
            (setOrSystemFn system cfg.default.extra-packages) // (setOrSystemFn system extra-packages);
        };
      }
  ) (builtins.removeAttrs cfg ["default"]));
}
