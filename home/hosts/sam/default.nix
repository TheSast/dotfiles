{
  imports = [
    {
      home.file.".config/scripts".source = ../../scripts;
      winget.packages = [
        "mpv-player.mpv-CI.MSVC"
        "jcardama.LeopardWM"
        # "yt-dlp.yt-dlp"
        # "yt-dlp.FFmpeg"
      ];
      # scoop.packages = [
      #   "extras/webcord"
      #   "main/git" # for extras
      #   "main/7zip" # for extras
      # ];
      home.sessionVariables.XDG_CONFIG_HOME = "%USERPROFILE%\.config";
      # order 2?
      # programs.powershell.profileExtra = pkgs.lib.mkOrder 99 ''
      #   $env:XDG_CONFIG_HOME = "$HOME\.config
      # '';
      windows.gaming = {
        gameMode = true;
        captures = false;
        gameBarWithController = false;
        fullscreenOptimizations = true;
      };
    }
    {
      home.file.".vieb".source = ../../Vieb;
      xdg = {
        configFile.Vieb = {
          source = ../../Vieb;
          recursive = true;
        };
      };
      winget.packages = ["Jelmerro.Vieb"];
    }
    (
      {flake, ...}: {
        xdg.configFile = {
          "scripts".source = ../../scripts;
          fastfetch = {
            target = "fastfetch/config.jsonc";
            text = import ../../fastfetch.nix {
              inherit
                flake
                ;
            };
          };
        };
        winget.packages = ["Fastfetch-cli.Fastfetch"];
      }
    )
    {
      # use .config?
      xdg.configFile."astronvim".source = ../../astronvim;
      winget.packages = ["Neovim.Neovim"];
      programs.powershell = {
        enable = true;
        initContent = ''$env:NVIM_APPNAME = "astronvim"'';
      };
    }
    {
      xdg.configFile."starship.toml".source = ../../starship/starship.toml;
      winget.packages = ["Starship.Starship"];
      programs = {
        starship.enable = false;
        powershell = {
          enable = true;
          initContent = ''
            function Invoke-Starship-TransientFunction {
              [Console]::Write("`n- `n")
            }
            Invoke-Expression (&starship init powershell)
            Enable-TransientPrompt
          '';
        };
      };
    }
    {
      xdg.configFile."AutoDarkMode/config.yaml" = {
        source = ../../AutoDarkMode/config.yaml;
        recursive = true;
      };
      winget.packages = ["ArminOsaj.AutoDarkMode"];
    }
  ];
}
