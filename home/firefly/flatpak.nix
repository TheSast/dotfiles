{
  services.flatpak = {
    packages = (import ../lib.nix).forceExplicitFlatpakPackageUpdate [
      {
        appId = "moe.launcher.an-anime-game-launcher";
        commit = "2627d5a22de403e4a3499c8c6299dfffe63918e573b838dbd48f447f1de4072e";
      }
      {
        appId = "moe.launcher.the-honkers-railway-launcher";
        commit = "87f6d208916a60c0f887e85d19d083c14ea1950053a01951304a8b844a822919";
      }
      {
        appId = "moe.launcher.sleepy-launcher";
        commit = "e1ab360fa230873a73726a890576f4f59a73e343e37dbf272d06b23a3e0d7e62";
      }
      {
        appId = "net.retrodeck.retrodeck";
        commit = "a86d30895e4f2fbd3127e2df49c5538ac6b7c78ff06d31c5e3c852c0d505db5c";
      }
    ];
    overrides = {
      # borken atm https://github.com/gmodena/nix-flatpak/issues/205
      # settings = {
      # Gamescope has no winewayland support
      "moe.launcher.an-anime-game-launcher".Context.sockets = [
        "x11"
      ];
      "moe.launcher.the-honkers-railway-launcher".Context.sockets = [
        "x11"
      ];
      "moe.launcher.sleepy-launcher".Context.sockets = [
        "x11"
      ];
      # };
    };
  };
}
