{
  config,
  pkgs,
  inputs,
  ...
}: let
  flakeLoc = "${config.xdg.configHome}/etc";
  symlinkDirectly = p: config.lib.file.mkOutOfStoreSymlink ("${flakeLoc}/home/" + p);
  gsettings-schemas = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.pname}-${pkgs.gsettings-desktop-schemas.version}";
in {
  services.gnome-keyring.enable = true;
  home.packages = with pkgs; [
    playerctl
    tofi
    udiskie
    glib
    libnotify
    niri
    inputs.noctalia.packages."${pkgs.stdenv.hostPlatform.system}".default
    wl-mirror
  ];
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3 = {
      theme = config.gtk.theme;
      extraCss = ''@import url("noctalia.css");'';
    };
    gtk4 = {
      theme = config.gtk.theme;
      extraCss = ''@import url("noctalia.css");'';
    };
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
    platformTheme.name = "qt6ct";
    style.name = config.qt.qt6ctSettings.Appearance.style;
    qt6ctSettings = {
      Appearance = {
        color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
        custom_palette = true;
        standard_dialogs = "default";
        style = "Fusion";
      };
    };
  };
  systemd.user.sessionVariables.GSETTINGS_SCHEMAS = gsettings-schemas;
  xdg = {
    systemDirs = {
      data = [gsettings-schemas];
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.niri
      ];
    };
    configFile = {
      niri = {
        source = symlinkDirectly "niri/config.kdl";
        target = "niri/config.kdl";
        recursive = true;
      };
      niri-kafka = {
        source = symlinkDirectly "niri/kafka.kdl";
        target = "niri/kafka.kdl";
        recursive = true;
      };
      niri-firefly = {
        source = symlinkDirectly "niri/firefly.kdl";
        target = "niri/firefly.kdl";
        recursive = true;
      };
      niri-xdg = {
        text =
          /*
          kdl
          */
          ''
            spawn-at-startup "${config.xdg.configHome}/scripts/niri-init.sh"
            screenshot-path "${config.xdg.userDirs.pictures}/Screenshots/%Y/%m/%d/%H-%M-%S.png"
          '';
        target = "niri/xdg.kdl";
      };
      noctalia = {
        source = ./noctalia;
        recursive = true;
      };
      noctalia-xdg = {
        text =
          /*
          toml
          */
          ''
            [theme.templates.user.tty]
            input_path = '${config.xdg.configHome}/noctalia/templates/tty'
            output_path = '${config.xdg.cacheHome}/noctalia-templates/tty'

            [theme.templates.user.tofi]
            input_path = '${config.xdg.configHome}/noctalia/templates/tofi'
            output_path = '${config.xdg.cacheHome}/noctalia-templates/tofi'
          '';
        target = "noctalia/xdg.toml";
        recursive = true;
      };
      tofi = {
        source = ./tofi;
        recursive = true;
      };
      tofi-inclues = {
        text =
          /*
          conf
          */
          ''
            include = ${config.xdg.cacheHome}/noctalia-templates/tofi
          '';
        target = "tofi/includes";
      };
      xdg-desktop-portal = {
        source = ./xdg-desktop-portal;
      };
    };
  };
}
