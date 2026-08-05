{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./flatpak.nix
    ./niri.nix
    ./steam.nix
  ];
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    eden
    linux-wallpaperengine
    mangohud
    prismlauncher
    protonup-ng
    xwayland-satellite
  ];
  # Create Steam CEF debugging file if it doesn't exist for Decky Loader.
  systemd.user.services.steam-cef-debug = {
    Unit = {
      Description = "Create Steam CEF debugging file";
    };
    Service = {
      RemainAfterExit = true;
      Type = "oneshot";
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "steam-cef-debug-script";
          text =
            /*
            sh
            */
            ''
              set -euo pipefail
              if [ -f ~/.steam/steam/.cef-enable-remote-debugging ]; then
                echo "Steam CEF debugging already set up"
                exit 0
              fi
              touch ~/.steam/steam/.cef-enable-remote-debugging
              echo "Steam CEF debugging setup complete"
            '';
        }
      );
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
  # Use steam cursor
  gtk.cursorTheme = lib.mkForce {
    package = null;
    name = "steam";
  };
}
