{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.steam-config-nix.homeModules.default
  ];

  programs.steam.config = {
    enable = true;
    onSteamRunning = "close";
    notifications = true;

    apps."2322010" = {
      name = "God of War Ragnarök";
      env.SteamDeck = 1;
    };

    nonSteamApps = {
      "Genshin Impact" = {
        target = pkgs.flatpak;
        startIn = config.home.homeDirectory;
        args = [
          "run"
          "--branch=stable"
          "--arch=x86_64"
          "--command=moe.launcher.an-anime-game-launcher"
          "moe.launcher.an-anime-game-launcher"
          "--just-run-game"
        ];
        preHook = ''
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            unset DISPLAY
          fi
        '';
        artwork = {
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/ac4e7a4f341e7281b0f6f274f9ec3905.png";
            hash = "sha256-trPmEhn4QEEUKFeUsXqIPdUgSHeuPfwRUepHS/5n+mw=";
          };
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/66ff583bc920263b0affd3c85e8a87d1.png";
            hash = "sha256-JZv/cEYo66kgiLtJVU3BSt9/EIaWWNYAPoJ0e5PHeeA=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/a0e58c078833b1ff8654ae48cdc26267.png";
            hash = "sha256-mxfFEkloHLlv/wPMwCFQR52XYmlicjJCp+TQViO3OuU=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/f39bd6151d360eb6be734461e33c9272.png";
            hash = "sha256-lzvvN71IDjb0OMf5c/pcIOTTDpEHWeZnlAvUJg8BwgE=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/944eefd22dfe99fe7631b8ecc732c7cf.png";
            hash = "sha256-87tPJJnnqy4LbHSM4RyMXIPWrPxRhYkra1MVy8vKK3E=";
          };
        };
      };
      "Honkai: Star Rail" = {
        target = pkgs.flatpak;
        startIn = config.home.homeDirectory;
        args = [
          "run"
          "--branch=stable"
          "--arch=x86_64"
          "--command=moe.launcher.the-honkers-railway-launcher"
          "moe.launcher.the-honkers-railway-launcher"
          "--just-run-game"
        ];
        preHook = ''
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            unset DISPLAY
          fi
        '';
        artwork = {
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/ec01a34f7fc3b03448cc52f2a89d52e8.png";
            hash = "sha256-QU9W9NzjMrDx5WxowjnCLX0MVSD9uP1MtM9tpdEy6Q8=";
          };
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/14219e4acfc4c50d323a47c2a6994299.png";
            hash = "sha256-WWozKyr4t5eAv7CsuFHiFrdJzX3NpWcEr9jWVs5OxuU=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/e94b343ad31f727f14fce141c6d1dd39.png";
            hash = "sha256-tbKK88qlciyR5bsMWIaHBEYzOKxTIadswOznNK8VtB4=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/6f61e7cf378ca73c9e07a049dbde7ba3.png";
            hash = "sha256-DWlPrbBBcFSlTWEddM2Y5bj+fuFcNCLU/EOyCPF6eI8=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/804bfd285116c91c935176b2b199894d.png";
            hash = "sha256-J8OuzDIKgRRnO+iUAGothi0fL2HY4+2AXbwRaYkmUeU=";
          };
        };
      };
      "Zenless Zone Zero" = {
        target = pkgs.flatpak;
        startIn = config.home.homeDirectory;
        args = [
          "run"
          "--branch=stable"
          "--arch=x86_64"
          "--command=moe.launcher.sleepy-launcher"
          "moe.launcher.sleepy-launcher"
          "--just-run-game"
        ];
        preHook = ''
          if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
            unset DISPLAY
          fi
        '';
        artwork = {
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/048617ceb68b40a45847078db347ba59.png";
            hash = "sha256-lytIcXC4mSKmHlX1QBrwu444n3FCtDJdbBShe3GR79I=";
          };
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/97657e12f1b8cbf71b6837f02b23d423.png";
            hash = "sha256-Zovkg/06lWRAiP127mRLVHPpmpfkEZGzAucLzSOt0qM=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/fb1c379f0c46eb1224cab79f519bffe2.png";
            hash = "sha256-YmIXfhSIBc+yReBR0PJk0odM/2xyibQ8e4qKb2CgJz0=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/8c3f348513ccf819c79fc556597faf31.png";
            hash = "sha256-IoKBlbXuoLlRZ26z00Jgv8r1vKSWugApCaJxrw82eZo=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/6636876050dcade8ec8e3023b1afe9bc.png";
            hash = "sha256-FXy8LrklOU3ee6tYW1ZhMk0eVU0LVLY/qrqN1jIKpms=";
          };
        };
      };
      "NT Mode" = {
        target = pkgs.writeShellScriptBin "reboot-into-nt-mode" "systemctl start reboot-into-nt-mode.service";
        startIn = config.home.homeDirectory;
        artwork = let
          artworkAndLogo =
            pkgs.runCommand "nt-mode-artwork-and-logo.png"
            {
              nativeBuildInputs = [pkgs.imagemagick];
              src = pkgs.fetchurl {
                url = "https://cdn2.steamgriddb.com/icon/e3a6bc816749a1dae44ddacbb8de3999.png";
                hash = "sha256-CjaNqH+mS/PwjpV+sjzTqwpEjZo/ReRyDUNiSk5Z6ww=";
              };
            }
            ''
              magick "$src" \
                  -channel A -threshold 0 \
                  -channel RGB -fill white -colorize 100 \
                  -resize 720x720 \
                  "$out"
            '';
        in {
          icon = artworkAndLogo;
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/5cac8a9dbef8b9a2b300976fcc421df5.jpg";
            hash = "sha256-K35ixGsymc+iftfvYniHj1e5G2Pdp3rv+thxuXf9CJ4=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/fa42f9968f3cdfca47c5d87004dc062b.jpg";
            hash = "sha256-STo1g998RlZvlssDktHhr03lfaU5Sbm+TsMX2RGlwtI=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/0257bc9c0ee6c0bf66ecdc2fd91a5135.png";
            hash = "sha256-zvXwcUj4CgnzgBtadN5a4SjFjXHxm93hcgRMeu4GSwY=";
          };
          logo = artworkAndLogo;
        };
      };
    };
  };
}
