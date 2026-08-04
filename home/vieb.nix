{
  pkgs,
  inputs,
  config,
  ...
}: {
  home = {
    packages = [
      (pkgs.symlinkJoin {
        # This wrapper prevents chromium from reading custom gtk css
        # If chromium reads custom gtk css, it stops listening for
        # dconf/gsettings colorscheme changes
        name = "vieb-wrapped";
        paths = [
          (inputs.vieb.packages."${pkgs.stdenv.hostPlatform.system}".default.override {
            # discord fails to load with older electron versions
            electron = pkgs.electron_42;
          })
        ];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          mkdir -p $out/hacks/empty
          mkdir -p $out/hacks/bin
          mv $out/bin/vieb $out/hacks/bin/vieb.real
          makeWrapper ${pkgs.bubblewrap}/bin/bwrap $out/bin/vieb \
            --add-flags "--dev-bind / /" \
            --add-flags "--bind $out/hacks/empty \"\''${XDG_CONFIG_HOME:-\$HOME/.config}/gtk-3.0"\" \
            --add-flags "--bind $out/hacks/empty \"\''${XDG_CONFIG_HOME:-\$HOME/.config}/gtk-4.0"\" \
            --add-flags "$out/hacks/bin/vieb.real"
        '';
      })
    ];
  };
  systemd.user.sessionVariables = {
    VIEB_CONFIG_FILE = "${config.xdg.configHome}/Vieb/viebrc";
    VIEB_DATAFOLDER = "${config.xdg.stateHome}/Vieb";
  };
  home.file.".vieb".source = ./Vieb;
  xdg = {
    configFile.Vieb = {
      source = ./Vieb;
      recursive = true;
    };
    desktopEntries = let
      mkErwic = args @ {
        name,
        appUrl,
        prependArg ? "",
        appendArg ? "",
        profileName ? name,
        ...
      }:
        (builtins.removeAttrs args [
          "appUrl"
          "prependArg"
          "appendArg"
          "profileName"
        ])
        // (
          let
            invalid = builtins.filter (x: builtins.hasAttr x args) [
              "exec"
              "icon"
              "terminal"
              "type"
            ];
          in
            if invalid != []
            then
              throw ''
                mkErwic: cannot redefine desktop entry attributes:
                  ${builtins.concatStringsSep ", " invalid}
              ''
            else {
              inherit name;
              exec = "vieb ${prependArg} --config-file=${config.xdg.configHome}/Vieb/Erwic/${profileName}/erwicrc --datafolder=${config.xdg.stateHome}/Erwic/${profileName} ${appendArg} ${appUrl}";
              icon = "${config.xdg.configHome}/Vieb/Erwic/${profileName}/icon.png";
              terminal = false;
              type = "Application";
            }
        );
    in {
      Discord = mkErwic {
        name = "Discord";
        appUrl = "https://discord.com/app";
        appendArg = "--disable-features=WebRtcAllowInputVolumeAdjustment";
        genericName = "Messaging Platform";
        categories = [
          "Network"
          "Chat"
          "InstantMessaging"
        ];
      };
      Element = mkErwic {
        name = "Element";
        appUrl = "https://app.element.io/";
        genericName = "Messaging Platform";
        categories = [
          "Network"
          "Chat"
          "InstantMessaging"
        ];
      };
      Bitwarden = mkErwic {
        name = "Bitwarden";
        appUrl = "https://vault.bitwarden.com/";
        genericName = "Password Manager";
        categories = ["Network"];
      };
      Protonmail = mkErwic {
        name = "Proton Mail";
        appUrl = "https://mail.proton.me/";
        profileName = "Proton_Mail";
        genericName = "Electronic Mail Client";
        categories = [
          "Network"
          "Email"
        ];
      };
      YouTube = mkErwic {
        name = "YouTube";
        appUrl = "https://youtube.com/";
        genericName = "Video Streaming Platform";
        categories = [
          # "Network"
          "AudioVideo"
        ]; # only one main category
      };
    };
  };
}
