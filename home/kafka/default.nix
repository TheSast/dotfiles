{pkgs, ...}: {
  home.stateVersion = "23.05"; # WARNING: do not touchy
  home.packages = with pkgs; [
    brightnessctl
  ];
}
