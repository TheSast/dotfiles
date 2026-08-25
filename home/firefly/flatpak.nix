{
  services.flatpak = {
    packages = (import ../lib.nix).forceExplicitFlatpakPackageUpdate [
      {
        appId = "moe.launcher.an-anime-game-launcher";
        commit = "03d801761e7285dbdd06f2f79f3edfaf104a52ad0c4f482a6738a81065c9d45a";
      }
      {
        appId = "moe.launcher.the-honkers-railway-launcher";
        commit = "924d9fdfe3c6a496a00071626859f9af771ec9c51d5e3c8f9fd3c08b5c47dd05";
      }
      {
        appId = "moe.launcher.sleepy-launcher";
        commit = "102a95ce237776ed09ecacc5a0e43ce83461e7a676750ddc0425e16fc0cff4bc";
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
