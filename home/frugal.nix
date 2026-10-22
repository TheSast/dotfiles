{
  pkgs,
  lib,
  ...
}:
let
  inherit (import ../lib.nix) copyBinary copyManpages;
in
{
  # source from every script
  xdg.configFile."script.path".text = ''
    PATH=$PATH:${
      lib.makeBinPath (
        with pkgs;
        [
          glib
          gnugrep
          libnotify
          uutils-coreutils-noprefix
          uutils-findutils
          uutils-hostname
          uutils-procps
          uutils-sed
          uutils-util-linux
          udiskie
        ]
      )
    }
  '';
  home.packages = with pkgs; [
    (
      let
        cmds = {
          xargs = pkgs.uutils-findutils;
          sed = pkgs.uutils-sed;
          pgrep = pkgs.uutils-procps;
          pkill = pkgs.uutils-procps;
          watch = pkgs.uutils-procps;
          free = pkgs.uutils-procps;
          pidwait = pkgs.uutils-procps;
        };

        bins =
          pkgs.runCommand "picky-uutils" { }
            #sh
            ''
              mkdir -p "$out/bin"
              ln -s "${pkgs.uutils-coreutils-noprefix}/bin"/* "$out/bin"/.
              for page in "${pkgs.uutils-coreutils}"/share/man/man*/*.*; do
                [ -f "$page" ] || continue
                section="$(basename "$(dirname "$page")")"
                mkdir -p $out/share/man/$section
                ln -s "$page" "$out/share/man/$section/$(basename "$page")"
              done
              ${builtins.concatStringsSep "\n" (
                lib.attrsets.mapAttrsToList (binName: pkg: ''
                  ${copyBinary pkg binName}
                  ${copyManpages pkg binName}
                '') cmds
              )}
            '';

        wrapper = pkgs.writeShellScriptBin "uutils" ''
          if [ "$#" -eq 0 ]; then
              echo "Usage: $(${pkgs.uutils-coreutils-noprefix}/bin/basename $0) CMD [ARG ...]" >&2
              echo "" >&2
              echo "CMD:" >&2
              ${pkgs.uutils-coreutils-noprefix}/bin/ls ${bins}/bin
              exit 2
          fi
          one=$1
          shift
          exec "${bins}/bin/$one" "$@"
        '';
      in
      pkgs.symlinkJoin {
        name = "uutils";
        paths = [ wrapper ];
        postBuild = ''
          mkdir -p "$out/share"
          ln -s "${bins}/share/man" "$out/share/man"
        '';
      }
    )
    (pkgs.runCommand "ncurses-clear-only" { } ''
      ${copyBinary pkgs.ncurses "clear"}
      ${copyManpages pkgs.ncurses "clear"}
    '')
    openssh
  ];
}
