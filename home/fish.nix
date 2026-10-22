{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    babelfish
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
    interactiveShellInit =
      # fish
      ''
        set -g fish_sequence_key_delay_ms 150
        abbr --add dotdotdot --position anywhere --regex '^\.{3,}\/*$' --function _multicd # can't go in fish.shellAbbrs because of `--regex`
        set -l tty_colors ${config.xdg.cacheHome}/noctalia-templates/fish
        test -f $tty_colors && source $tty_colors
        ${lib.getExe pkgs.starship} init fish --print-full-init | source && enable_transience
        functions -e l ll ls enable_transience disable_transience funcsave funced export cdh dirh
      '';
    functions = {
      boy =
        # fish
        ''
          if test $argv[1] = --help
              echo boy - a prettier way to read program help pages
              return
          end
          $argv --help 2>&1 | ${lib.getExe pkgs.bat} --plain --language=help
        '';
      cd =
        # fish
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
        # fish
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
        # fish
        ''
          if test "$argv[1]" = profile
              if not set -q XDG_RUNTIME_DIR
                echo "XDG_RUNTIME_DIR not set" >&2
                return 1
              end
              if not string match -q -- --profile $argv
                echo "Info: 'nix profile' is not declarative. The default profile is ephemeral, meaning it's contents will be wiped when the user session ends."
              end
              if test (count $argv) -gt 1
                  ${pkgs.coreutils}/bin/mkdir -p $XDG_RUNTIME_DIR/nix-tmpinstall
                  command nix profile $argv[2] --profile $XDG_RUNTIME_DIR/nix-tmpinstall/profile $argv[3..]
                  return $status
              else
                  command nix $argv
                  return $status
              end
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
        # fish
        ''
          if string match -q -r -- / $argv[1]
              echo (string repeat -n (math (string length -- (string replace -a / "" $argv[1])) - 1) ../)
          else
              echo (string join "" (string repeat -n (math (string length -- $argv[1]) - 2) ../) ..)
          end
        '';
      _multicd_expr =
        # fish
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
        # fish
        ''
          echo -e -n "\n- \n"
        '';
      fish_user_key_bindings =
        #fish
        ''
          bind --erase --preset alt-e
          bind --preset escape 'if commandline -P; commandline -f cancel; else; edit_command_buffer; __fish_cursor_xterm line; end'
        '';
      z =
        # fish
        ''
          __zoxide_setup
          function __zoxide_setup
          end
          __zoxide_z $argv || return
          _cd_git_info
        '';
      __zoxide_setup =
        # fish
        ''
          ${lib.getExe pkgs.zoxide} init fish --no-cmd | source
        '';
    };
  };
}
