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
    # remove bash (programs.bash and shadow.nix and user-groups.sh)
    # all used shells are added to environment.systemPackages, but pkgs.shadow is the default even for non-static users
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
      # remove fish https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/programs/fish.nix#L431-L436
      useBabelfish = true;
    };
    less.enable = lib.mkForce false; # https://github.com/NixOS/nixpkgs/pull/580229
    nano.enable = false;
    command-not-found.enable = false;
    dconf.enable = true;
  };
  documentation.doc.enable = false;
  environment = {
    binsh = lib.getExe pkgs.dash;
    defaultPackages = [];
    corePackages = lib.mkForce [ ];
    # should remove plymouth
    # should remove PAGER and less https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/programs/environment.nix#L26
  };
}
