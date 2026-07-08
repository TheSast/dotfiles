{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  flakeLoc = "${config.xdg.configHome}/etc";
  symlinkDirectly = p: config.lib.file.mkOutOfStoreSymlink ("${flakeLoc}/home/" + p);
  gsettings-schemas = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.pname}-${pkgs.gsettings-desktop-schemas.version}";
in {
  imports = [
    ./secrets.nix
    ./niri.nix
    ./hyprland.nix
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
        "obsidian"
      ];
  };
  home.packages = with pkgs; [
    alacritty
    asciinema
    atuin
    babelfish
    bat
    broot
    btop
    cliphist
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
    glib
    glow
    inlyne
    lazygit
    libnotify
    losslesscut-bin
    mpv
    neovide
    (pkgs.writeShellApplication {
      name = "nvim";
      runtimeInputs = with pkgs;
        [pkgs.neovim-unwrapped]
        ++ [
          # lsp
          alejandra
          deadnix
          lua-language-server
          luajitPackages.luacheck
          selene
          tinymist
          nil
          vscode-json-languageserver # neoconf
          statix
          stylua
        ]
        ++ [
          # build
          gcc # nvim-treesitter
          git # lazy.nvim # luarocks.nvim # blink.cmp # snacks.nvim
          luajit # luarocks.nvim
          unzip # luarocks.nvim
          gnumake # jsregexp for LuaSnip
          ripgrep # telescope-fzf-native.nvim # snacks.nvim
          curl # blink.cmp
          fd # snacks.nvim
          # xdg-utils?
          # wl-clipboard?
        ];
      text = ''exec nvim "$@"'';
    })
    networkmanagerapplet
    (lib.hiPrio (
      pkgs.runCommand "nm-applet.desktop-hide" {} ''
        mkdir -p "$out/share/applications"
        cat "${networkmanagerapplet}/share/applications/nm-connection-editor.desktop" > "$out/share/applications/nm-connection-editor.desktop"
        echo "Hidden=1" >> "$out/share/applications/nm-connection-editor.desktop"
      ''
    ))
    nh
    obsidian
    onefetch
    ouch
    playerctl
    polkit_gnome
    ripgrep
    swayimg
    awww
    tabiew
    tmux
    tofi
    trash-cli
    udiskie
    (inputs.vieb.packages."${pkgs.stdenv.hostPlatform.system}".default.override {
      electron = pkgs.electron_42;
    })
    # luakit
    # qutebrowser
    # vimb
    # nyxt
    # floorp
    # helium
    wallust
    waybar
    wf-recorder
    wl-clipboard
    wob
    xdg-utils
    zathura
    zellij
    zoxide
  ];

  home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    desktopEntries = {
      Discord = {
        name = "Discord";
        genericName = "Messaging Platform";
        exec = "vieb --config-file=${config.xdg.configHome}/Vieb/Erwic/Discord/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/Discord https://discord.com/app";
        icon = "${config.xdg.configHome}/Vieb/Erwic/Discord/icon.png";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "Chat"
          "InstantMessaging"
        ];
      };
      Element = {
        name = "Element";
        genericName = "Messaging Platform";
        exec = "vieb --config-file=${config.xdg.configHome}/Vieb/Erwic/Element/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/Element https://app.element.io/";
        icon = "${config.xdg.configHome}/Vieb/Erwic/Element/icon.png";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "Chat"
          "InstantMessaging"
        ];
      };
      Bitwarden = {
        name = "Bitwarden";
        genericName = "Password Manager";
        exec = "vieb --config-file=${config.xdg.configHome}/Vieb/Erwic/Bitwarden/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/Bitwarden https://vault.bitwarden.com/";
        icon = "${config.xdg.configHome}/Vieb/Erwic/Bitwarden/icon.png";
        terminal = false;
        type = "Application";
        categories = ["Network"];
      };
      Protonmail = {
        name = "Proton Mail";
        genericName = "Electronic Mail Client";
        exec = "vieb --config-file=${config.xdg.configHome}/Vieb/Erwic/Proton_Mail/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/Proton_Mail https://mail.proton.me/";
        icon = "${config.xdg.configHome}/Vieb/Erwic/Proton_Mail/icon.png";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "Email"
        ];
      };
      YouTube = {
        name = "YouTube";
        genericName = "Video Streaming Platform";
        exec = "vieb --config-file=${config.xdg.configHome}/Vieb/Erwic/YouTube/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/YouTube https://youtube.com/";
        icon = "${config.xdg.configHome}/Vieb/Erwic/YouTube/icon.png";
        terminal = false;
        type = "Application";
        categories = [
          # "Network"
          "AudioVideo"
        ]; # only one main category
      };
    };
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
    systemDirs = {
      data = [gsettings-schemas];
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
            import = ["${config.xdg.cacheHome}/wallust/alacritty.toml"]
          '';
        target = "alacritty/alacritty.toml";
      };
      astronvim = {
        source = symlinkDirectly "astronvim";
      };
      atuin = {
        source = ./atuin;
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
            config
            pkgs
            lib
            flakeLoc
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
      hypr = {
        source = symlinkDirectly "hypr";
      };
      lazygit = {
        source = ./lazygit;
      };
      neofetch = {
        source = ./neofetch;
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
      tofi = {
        source = ./tofi;
      };
      Vieb = {
        source = ./Vieb;
        recursive = true;
      };
      wallust = {
        source = ./wallust;
        recursive = true;
      };
      wallust-toml = {
        text =
          /*
          toml
          */
          ''
            [templates]
            alacritty = { template = "alacritty.toml", target = "${config.xdg.cacheHome}/wallust/alacritty.toml" }
            tty = { template = "tty.sh", target = "${config.xdg.cacheHome}/wallust/tty.sh" }
          '';
        target = "wallust/wallust.toml";
      };
      waybar = {
        source = ./waybar;
      };
    };
    # list executables via `ls -1  $XDG_STATE_DIR/nix/profile/bin/ | sed -E 's%.*-> .{43}-%%g' | sort`
    dataFile = {
      "current-user-packages".text = let
        packages = builtins.map (p: "${p.name}") config.home.packages;
        sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
        formatted;
    };
  };

  home.file = {
    ".bash_profile" = {
      source = ./bash/login.bash;
    };
    ".bashrc" = {
      text =
        ''
          eval "$(${lib.getExe pkgs.starship} init bash)"
        ''
        + (builtins.readFile ./bash/nonlogin.bash);
    };
    ".vieb" = {
      source = ./Vieb;
    };
    ".ssh/config" = {
      source = ./ssh/config;
    };
    # ssh keys handled via ./secrets.nix
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = config.gtk.theme;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk2";
  };

  # Shell variables
  home.sessionVariables =
    config.systemd.user.sessionVariables
    // {
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
    };

  # Session variables
  # These are picked up by GDM and KDE Plasma (apparently) but not by SDDM (which loads your shell config) or other DMs
  systemd.user.sessionVariables = {
    GSETTINGS_SCHEMAS = gsettings-schemas;
    XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
    XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
    XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
    XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
    XDG_VIDEOS_DIR = config.xdg.userDirs.videos;
    XDG_MUSIC_DIR = config.xdg.userDirs.music;
    VIEB_CONFIG_FILE = "${config.xdg.configHome}/Vieb/viebrc";
    VIEB_DATAFOLDER = "${config.xdg.stateHome}/Vieb";
    NVIM_APPNAME = "astronvim";
    VISUAL = "nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # enable wayland detection for some electron apps (notably: yes obsidian, yes vieb)
  };

  home.shellAliases = {
    mv = "mv -i";
    eza = "${lib.getExe pkgs.eza} --icons auto --git";
  };

  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };
  programs.command-not-found.enable = false;
  programs.fish = {
    enable = true;
    package = let
      fishNoDesktop = pkgs.symlinkJoin {
        name = "fish-no-desktop";
        paths = [pkgs.fish];

        postBuild = ''
          rm -f $out/share/applications/fish.desktop
        '';
      };
    in
      fishNoDesktop;
    shellInit = ''
      set fish_greeting
    '';
    functions = {
      boy =
        /*
        fish
        */
        ''
          if test $argv[1] = --help
              echo boy - a prettier way to read program help pages
              return
          end
          $argv --help 2>&1 | bat --plain --language=help
        '';
      cd =
        /*
        fish
        */
        ''
          builtin cd $argv || return
          _cd_git_info
        '';
      # IDEA:
      # from https://github.com/oh-my-fish/plugin-cd
      # cd .../foo           # <=> cd ../../foo
      # cd ...               # <=> cd ../..
      # cd .../foo/.../bar   # <=> cd ../../foo/../../bar
      # pwd                  # ~/a
      # cd ~/b               # ~/b    ( dirstack: a )
      # cd ~/c               # ~/c    ( dirstack: b a )
      # cd ~/d               # ~/d    ( dirstack: c b a )
      # cd -2                # ~/b    ( dirstack: d c a )
      # cd +1                # ~/c    ( dirstack: b d a )
      # cd +0                # ~/a    ( dirstack: c b d )
      # cd -0                # ~/a    ( dirstack: c b d )
      _cd_git_info =
        /*
        fish
        */
        ''
          set -l current_repository (${lib.getExe pkgs.git} rev-parse --show-toplevel 2> /dev/null)
          if string length -q -- $current_repository && not string match -q -- $current_repository $__last_repository
            functions -c fish_prompt fish_prompt_bak
            functions -e fish_prompt
            function fish_prompt
              functions -e fish_prompt
              functions -c fish_prompt_bak fish_prompt
              functions -e fish_prompt_bak
              ! ${lib.getExe pkgs.onefetch} --include-hidden --no-bots 2> /dev/null
              set -g TRANSIENT $status
              fish_prompt
              set -e TRANSIENT
            end
            set -gx __last_repository $current_repository
          end
        '';
      nix-build = ''echo "Error: 'nix-build' is deprecated. Please use 'nix build' instead."'';
      nix-collect-garbage = ''echo "Error: 'nix-collect-garbage' is deprecated. Please use 'nix gc' instead."'';
      nix-daemon = ''echo "Error: 'nix-daemon' is deprecated. Please use 'nix daemon' instead."'';
      nix-env = ''echo "Error: 'nix-env' is deprecated. Please use 'nix profile' instead."'';
      nix-hash = ''echo "Error: 'nix-hash' is deprecated. Please use 'nix hash' instead."'';
      nix-shell = ''echo "Error: 'nix-shell' is deprecated. Please use 'nix develop' instead."'';
      nix =
        /*
        fish
        */
        ''
          if test "$argv[1]" = profile
              echo "Error: 'nix profile' is not declarative. Aborting."
              return 1
          end
          if contains -- "$argv[1]" build shell develop
              if contains -- "$argv[1]" shell develop && not string match -q -- --command $argv && not string match -q -- -c $argv && not string match -q -- --help $argv
                  command ${lib.getExe pkgs.nix-output-monitor} $argv --command $SHELL
                  return $status
              else
                  command ${lib.getExe pkgs.nix-output-monitor} $argv
                  return $status
              end
          end
          if test "$argv[1]" = gc
            command nix profile wipe-history $argv[2..]
            set -l retv $status
            if test $retv -eq 0 && not string match -q -- --help $argv
              command nix store gc
              return $status
            end
            return $retv
          end
          command nix $argv
        '';
      _multicd =
        /*
        fish
        */
        ''
          if string match -q -r -- / $argv[1]
              echo (string repeat -n (math (string length -- (string replace -a / "" $argv[1])) - 1) ../)
          else
              echo (string join "" (string repeat -n (math (string length -- $argv[1]) - 2) ../) ..)
          end
        '';
      _multicd_expr =
        /*
        fish
        */
        ''
          set acc
          for str in (string split -- "/" $argv)
              if string match -q --regex "\.{3,}\/*" -- $str
                  set acc (string join "/" $acc (_multicd $str))
              else
                  set acc (string join "/" $acc $str)
              end
          end
          echo $acc
        '';
      starship_transient_prompt_func =
        /*
        fish
        */
        ''
          echo -e -n "\n- \n"
        '';
      fish_hybrid_key_bindings =
        /*
        fish
        */
        ''
          # would use fish_user_key_bindings but starship / default prompt only displays mode with fish_vi_key_bindings or fish_hybrid_key_bindings
          bind --erase --all --preset

          if test "$fish_key_bindings" != fish_hybrid_key_bindings
            __fish_change_key_bindings fish_hybrid_key_bindings || return
          end

          for mode in insert replace
              fish_default_key_bindings -M $mode
          end
          fish_vi_key_bindings --no-erase

          for mode in default visual insert replace replace_one
            bind -e --preset -M $mode ctrl-l
            bind -e --preset -M $mode ctrl-y
            bind -e --preset -M $mode ctrl-m
            bind -e --preset -M $mode alt-.
            bind -e --preset -M $mode alt-e
            bind -e --preset -M $mode alt-l
            bind -e --preset -M $mode alt-v
            bind -e --preset -M $mode alt-w
            bind -e --preset -M $mode alt-y
            bind -e --preset -M $mode enter
          end
          for mode in default visual
            bind -e --preset -M $mode backspace
            bind -e --preset -M $mode ctrl-d
            bind -e --preset -M $mode ctrl-u
            bind -e --preset -M $mode ctrl-w
            bind -e --preset -M $mode tab
          end
          bind --preset -M insert ctrl-n down-or-search
          bind -e --preset -M default ctrl-c
          bind -e --preset -M replace ctrl-c
          bind -e --user -M default enter # remove transient_execute by starship
          bind --preset -M insert enter execute
          bind --preset -M default escape 'if commandline -P; commandline -f cancel; else; edit_command_buffer; end'
          for mode in insert replace
            bind --preset -M $mode ctrl-d delete-char
            bind --preset -M $mode ctrl-d delete-char
          end
          bind --preset -M replace enter insert-line-over
          # prevent escape sequences from triggering the escape key bind
          for mode in default visual insert replace
            for map in a b c d e f g h i j k l m n o p q r s t u v x y z 0 1 2 3 4 5 6 7 8 9 . \\ \| '\x20' '\x7F' '\r' '\t'
              if not bind --preset -M $mode (string join "" \e $map) &> /dev/null
                bind --preset -M $mode (string join "" \e $map) self-insert
              end
            end
            for map in (bind -K)
              if not bind --preset -M $mode $map &> /dev/null
                bind --preset -M $mode $map self-insert
              end
            end
          end
        '';
      z =
        /*
        fish
        */
        ''
          __zoxide_z $argv || return
          _cd_git_info
        '';
    };
    interactiveShellInit =
      /*
      fish
      */
      ''
        fish_hybrid_key_bindings
        set -g fish_sequence_key_delay_ms 150
        abbr --add dotdotdot --position anywhere --regex '^\.{3,}\/*$' --function _multicd # can't go in fish.shellAbbrs because of `--regex`
        set fish_cursor_default block
        set fish_cursor_visual block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
        set fish_cursor_replace underscore
        set fish_cursor_external line blink
        functions -e l
        functions -e la
        functions -e ll
        functions -e ls
        sh ${config.xdg.cacheHome}/wallust/tty.sh
        eval (${lib.getExe pkgs.starship} init fish) && enable_transience
        ${lib.getExe pkgs.zoxide} init fish | source
        source ${config.xdg.configHome}/fish/functions/z.fish
        ${lib.getExe pkgs.atuin} init fish --disable-up-arrow | source
      '';
  };
  news.display = "silent";
}
