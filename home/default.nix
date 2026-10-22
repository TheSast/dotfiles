{
  config,
  pkgs-extra,
  lib,
  pkgs,
  ...
}: let
  symlinkDirectly = (import ../lib.nix).symlinkDirectly config;
in {
  imports = [
    ./secrets.nix
    ./modules

    ./cli-tui.nix
    ./editor.nix
    ./fish.nix
    ./flatpak.nix
    ./frugal.nix
    ./niri.nix
    ./nix.nix
    ./shell.nix
    ./terminal.nix
    ./tmp-install.nix
    ./vcs.nix
    ./vieb.nix
  ];
  home.homeDirectory = "/home/${config.home.username}";

  home.packages = with pkgs; [
    inlyne
    networkmanagerapplet
    (lib.hiPrio (
      pkgs.runCommand "nm-applet.desktop-hide" {} ''
        mkdir -p "$out/share/applications"
        cat "${networkmanagerapplet}/share/applications/nm-connection-editor.desktop" > "$out/share/applications/nm-connection-editor.desktop"
        echo "Hidden=1" >> "$out/share/applications/nm-connection-editor.desktop"
      ''
    ))
    (pkgs.symlinkJoin {
      name = "nh-with-env";
      paths = [ pkgs.nh ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/nh" \
          --prefix PATH : ${
            pkgs.runCommand "coreutils-env-only" { } ''
              mkdir -p "$out/bin"
              ln -s "${pkgs.coreutils}/bin/env" "$out/bin/env"
            ''
          }/bin
      '';
    })
    pkgs-extra.ragenix
    swayimg
    trash-cli
    wf-recorder
    wl-clipboard
    xdg-utils
    (pkgs.runCommand "picky-coreutils" { } ''
      # ISSUE: fixme
      mkdir -p "$out/bin"
      mkdir -p "$out/share/man/man1"
      ln -s "${pkgs.coreutils}/bin/cat" "$out/bin/cat" # fixes nvim?
      ln -s "${pkgs.coreutils}/share/man/man1/cat.1.gz" "$out/share/man/man1/cat.1.gz"
    '')
  ];

  home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
    };
    userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
    };
    configFile = {
      scripts = {
        source = symlinkDirectly "scripts";
      };
      swayimg = {
        source = ./swayimg;
      };
    };
  };

  home.file = {
    ".ssh/config" = {
      source = ./ssh/config;
    };
    # ssh keys handled via ./secrets.nix
  };

  # aka home.userSessionVariables
  systemd.user.sessionVariables = {
    XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
    XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
    XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
    XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
    XDG_VIDEOS_DIR = config.xdg.userDirs.videos;
    XDG_MUSIC_DIR = config.xdg.userDirs.music;
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  }
  // (builtins.mapAttrs (
    env: values: lib.mkOverride 99 (config.lib.shell.prependToVar ":" env values)
  ) ((config.home.sessionSearchVariables or { }) // { PATH = config.home.sessionPath; }));

  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };
  programs.command-not-found.enable = false;
  news.display = "silent";
}
