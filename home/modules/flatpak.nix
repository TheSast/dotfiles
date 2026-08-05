{
  config,
  lib,
  ...
}: let
  cfg = config.services.flatpak;
in {
  options.services.flatpak.setVars = lib.mkOption {
    type = lib.types.bool;
    default = cfg.enable;
    description = "Set variables related to user-level Flatpaks.";
  };

  config = lib.mkIf cfg.setVars {
    # Make applications installed with `flatpak --user` visible to the desktop environment.
    xdg.systemDirs.data = ["${config.xdg.dataHome}/flatpak/exports/share"];

    # Make binaries exported by user-installed Flatpaks available in PATH.
    home.sessionPath = [
      "${config.xdg.dataHome}/flatpak/exports/bin"
    ];
  };
}
