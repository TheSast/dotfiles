{
  config,
  pkgs,
  lib,
  ...
}: let
  mkSessionArg = flag: dir: let
    sessions = builtins.concatStringsSep ":" (
      map (p: "${p}/${dir}") (
        lib.filter (p: builtins.pathExists "${p}/${dir}") config.services.displayManager.sessionPackages
      )
    );
  in
    lib.optionalString (sessions != "") " ${flag} ${sessions}";
in {
  services.displayManager.sessionPackages = with pkgs; [
    niri
  ];
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command =
          "${lib.getExe pkgs.tuigreet}"
          + " --remember --remember-user-session"
          + mkSessionArg "--sessions" "share/wayland-sessions"
          + mkSessionArg "--xsessions" "share/xsessions";
        user = "greeter";
      };
    };
  };
}
