{
  pkgs,
  lib,
  config,
  ...
}: {
  system.tools = {
    nixos-enter.enable = false;
    nixos-option.enable = false;
    nixos-install.enable = false;
    nixos-rebuild.enable = false;
    nixos-version.enable = false;
    nixos-build-vms.enable = false;
    nixos-generate-config.enable = false;
  };
  boot.enableContainers = false;
  programs = {
    fish = {
      enable = true;
      package = let
        fishNoDesktop = pkgs.symlinkJoin {
          name = "fish-no-desktop";
          paths = [pkgs.fish];
          inherit (pkgs.fish) meta;
          postBuild = ''
            rm -f $out/share/applications/fish.desktop
          '';
        };
      in
        fishNoDesktop;
      useBabelfish = true;
    };
    nano.enable = false;
    command-not-found.enable = false;
    dconf.enable = true;
  };
  documentation.doc.enable = false;
  environment = {
    binsh = lib.getExe pkgs.dash;
    defaultPackages = [];
  };
}
