{
  config,
  pkgs-extra,
  flake,
  lib,
  pkgs,
  ...
}: let
  flakeLoc = "${config.xdg.configHome}/etc";
  symlinkDirectly = p: config.lib.file.mkOutOfStoreSymlink ("${flakeLoc}/home/" + p);
in {
  imports = [
    ./secrets.nix
    ./niri.nix
    ./vieb.nix
    ./fish.nix
    ./flatpak.nix
    ./frugal.nix
    ./modules
  ];
  home = {
    username = "u";
    homeDirectory = "/home/u";
  };

  nix = {
    settings.use-registries = false;
    settings.flake-registry = "";
    keepOldNixPath = false;
    nixPath = [];
  };
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true; # affects home.profileDirectory
    };
    package = pkgs.nix;
  };

  nixpkgs.config = {
    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # I'm free!
      ];
  };
  home.packages = with pkgs; [
    alacritty
    asciinema
    bat
    broot
    btop
    difftastic
    dust
    erdtree
    eza
    (pkgs.writeShellApplication {
      name = "fetch";
      runtimeInputs = [
        hyfetch
        fastfetch
      ];
      text = ''exec hyfetch -b fastfetch "$@"'';
    })
    fd
    fzf
    gh
    git
    glow
    inlyne
    jjui
    jujutsu
    less
    lazygit
    lazyjj
    neovide
    (import ./nvim.nix {
      inherit pkgs;
      isolated = false;
    })
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
    ouch
    ripgrep
    pkgs-extra.ragenix
    swayimg
    tabiew
    tmux
    trash-cli
    # luakit
    # qutebrowser
    # vimb
    # nyxt
    # floorp
    # helium
    wf-recorder
    wl-clipboard
    xdg-utils
    zellij
    zoxide
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
    systemDirs = {
      config = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/etc/xdg" ];
      data = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share" ];
    };
    userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
    };
    configFile = {
      alacritty-toml = {
        text =
          /*
          toml
          */
          ''
            [font]
            size = 12

            [font.bold]
            family = "FiraCode Nerd Font"
            style = "Bold"

            [font.bold_italic]
            family = "FiraCode Nerd Font"
            style = "BoldItalic"

            [font.italic]
            family = "FiraCode Nerd Font"
            style = "MediumItalic"

            [font.normal]
            family = "FiraCode Nerd Font"
            style = "Medium"

            [general]
            import = ["${config.xdg.configHome}/alacritty/themes/noctalia.toml"]
          '';
        target = "alacritty/alacritty.toml";
      };
      astronvim = {
        source = symlinkDirectly "astronvim";
      };
      bat = {
        target = "bat/config";
        text = "--theme=ansi";
      };
      erdtree = {
        source = ./erdtree;
      };
      fastfetch = {
        target = "fastfetch/config.jsonc";
        text = import ./fastfetch.nix {
          inherit
            flake
            ;
        };
      };
      git = {
        source = symlinkDirectly "git";
      };
      hyfetch = {
        target = "hyfetch.json";
        source = ./hyfetch.json;
      };
      jj = {
        source = symlinkDirectly "jj";
      };
      lazygit = {
        source = ./lazygit;
      };
      npm = {
        source = ./npm;
      };
      readline = {
        source = ./readline;
      };
      scripts = {
        source = symlinkDirectly "scripts";
      };
      swayimg = {
        source = ./swayimg;
      };
      starship = {
        source = ./starship;
      };
      tmux = {
        source = ./tmux;
      };
      tmux-powerline = {
        source = ./tmux-powerline;
      };
    };
  };

  home.file = {
    ".bash_profile" = {
      source = ./bash/login.bash;
    };
    ".bashrc" = {
      text = import ./bash/nonlogin.nix { inherit pkgs; };
    };
    ".ssh/config" = {
      source = ./ssh/config;
    };
    # ssh keys handled via ./secrets.nix
  };

  # Shell variables
  home.sessionVariables = {
    HISTCONTROL = builtins.concatStringsSep ":" config.programs.bash.historyControl;
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    MANPAGER = "less -R --use-color -Dd+r -Du+b";
    MANROFFOPT = "-P -c";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship/starship.toml";
    EDITOR = config.home.sessionVariables.VISUAL;
    inherit (config.systemd.user.sessionVariables) VISUAL;
  };

  home.sessionPath = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/bin" ];

  home.sessionSearchVariables = {
    INFOPATH = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share/info" ];
    XCURSOR_PATH = [
      "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/bin"
    ];
    TERMINFO_DIRS = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share/terminfo" ];
    GTK_PATH = [
      "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-2.0"
      "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-3.0"
      "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-4.0"
    ];
    LIBEXEC_PATH = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/libexec" ];
  };
  # Session variables
  # These are picked up by GDM and KDE Plasma (apparently) but not by SDDM (which loads your shell config) or other DMs
  systemd.user.sessionVariables = {
    XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
    XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
    XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
    XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
    XDG_VIDEOS_DIR = config.xdg.userDirs.videos;
    XDG_MUSIC_DIR = config.xdg.userDirs.music;
    NVIM_APPNAME = "astronvim";
    VISUAL = "nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # enable wayland detection for some electron apps (notably: yes obsidian, yes vieb)
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
