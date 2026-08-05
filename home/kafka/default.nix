{pkgs, ...}: {
  imports = [
    ./niri.nix
  ];
  home.stateVersion = "23.05"; # WARNING: do not touchy
  home.packages = let
    kdeconnectNoDesktop = pkgs.symlinkJoin {
      name = "kdeconnect-no-desktop";
      paths = [pkgs.kdePackages.kdeconnect-kde];
      meta = pkgs.kdePackages.kdeconnect-kde;
      postBuild = ''
        for f in \
          org.kde.kdeconnect.nonplasma.desktop \
          org.kde.kdeconnect.sms.desktop
        do
          target="$out/share/applications/$f"
          if [ -L "$target" ]; then
            cat "$target" > "$target.tmp"
            rm "$target"
            mv "$target.tmp" "$target"
          fi
          echo "NoDisplay=true" >> "$target"
        done
      '';
    };
  in
    with pkgs; [
      brightnessctl
      kdeconnectNoDesktop
    ];
}
