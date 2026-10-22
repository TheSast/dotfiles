{
  config,
  pkgs,
  ...
}:
let
  symlinkDirectly = (import ../lib.nix).symlinkDirectly config;
in
{
  home.packages = with pkgs; [
    gh
    git
    jjui
    jujutsu
    lazygit
    lazyjj
  ];
  xdg.configFile = {
    git = {
      source = symlinkDirectly "git";
    };
    jj = {
      source = symlinkDirectly "jj";
    };
    lazygit = {
      source = ./lazygit;
    };
    scripts = {
      source = symlinkDirectly "scripts";
    };
    swayimg = {
      source = ./swayimg;
    };
  };
}
