{pkgs, ...}: {
  home.packages = with pkgs; [
    kanshi
  ];
  xdg.configFile = {
    kanshi = {
      source = ../kanshi;
    };
    niri-host = {
      text = ''include "kafka.kdl"'';
      target = "niri/host.kdl";
    };
  };
}
