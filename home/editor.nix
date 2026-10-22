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
    (import ./nvim.nix {
      inherit pkgs;
      isolated = false;
    })
    neovide
  ];
  systemd.user.sessionVariables = {
    NVIM_APPNAME = "astronvim";
    VISUAL = "nvim";
  };
  xdg.configFile.astronvim.source = symlinkDirectly "astronvim";
}
