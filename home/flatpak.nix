{
  inputs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  home.packages = [
    pkgs-unstable.flatpak
  ];
  services = {
    flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      # only works for those that have allowAutoUpdate = true
      update.auto = {
        enable = true;
        onCalendar = "hourly";
      };
      remotes = lib.mkOptionDefault [
        # dont' override flathub
        {
          name = "gnome-nightly";
          location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
        }
      ];
      packages = (import ./lib.nix).forceExplicitFlatpakPackageUpdate [
        # FIXME: incorrect commit only gives a server 404, same thing with incorrect format
        {
          appId = "no.mifi.losslesscut";
          commit = "6149edf7b898076ff81c1d55e52451fde0857494925f550daca90f9b77c4f391";
        }
        # ISSUE: doesn't follow theme
        {
          appId = "io.github.celluloid_player.Celluloid";
          commit = "0696c5f2697218d566e51dbb81935e986621bf63c68d7a5a6bf0a574e6a6a22b";
        }
        # ISSUE: doesn't follow theme
        {
          appId = "org.gnome.Evince";
          commit = "9f0403ef260ec7a60409742bc04348dc5d636cb7781ca03b589594e3437855ed";
        }
        # ISSUE: doesn't follow theme
        # ISSUE: https://github.com/gmodena/nix-flatpak/issues/216
        {
          appId = "com.bitwarden.desktop";
          commit = "66d1f3b52e9c42a150089a47d69914bf68b58c05f1bd8fc9f932ea7f186c64b8";
        }
        {
          appId = "org.gnome.Nautilus.Devel";
          commit = "e29623f8951ac4e363d6c7be337de1d9fceaf7a6e607b52bcb79bc199b06e584";
          origin = "gnome-nightly";
        }
      ];
      overrides = {
        pruneUnmanagedOverrides = true;
        settings = {
          global = {
            Context = {
              filesystems = [
                "xdg-config/gtk-2.0:ro"
                "xdg-config/gtk-3.0:ro"
                "xdg-config/gtk-4.0:ro"
              ];
              sockets = [
                "wayland"
                "!x11"
                "!fallback-x11"
              ];
            };
          };
          "org.gnome.Nautilus.Devel".Context = {
          };
          "org.gnome.Evince".Context = {
          };
          "io.github.celluloid_player.Celluloid".Context = {
            filesystems = [
              # "xdg-config/gtk-2.0:ro"
              # "xdg-config/gtk-3.0:ro"
              # "xdg-config/gtk-4.0:ro"
              # related to https://github.com/celluloid-player/celluloid/issues/703 ? flatpak-only issue
            ];
          };
        };
      };
    };
  };
}
