{
  lib,
  pkgs,
  call-flake,
}: {
  applyPatches = {
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
        patches =
          map (
            patch:
              if lib.isPath patch
              then patch
              else pkgs.fetchpatch2 patch
          )
          patches;
      }).overrideAttrs (_: prevAttrs: {
        outputs = ["out" "narHash"];
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
      });

    lockFilePath = "${patched.outPath}/flake.lock";
    lockFile = builtins.unsafeDiscardStringContext (lib.generators.toJSON {} (
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
    ));
  in
    (import "${call-flake}/call-flake.nix") lockFile {
      root = {
        sourceInfo = {
          inherit (patched) outPath;
        };
        subdir = "";
      };
    };
}
