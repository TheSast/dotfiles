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
  # HACK:
  environment.loginShellInit = ''
    # environment.d support
    # some display managers source /etc/profile and ~/.profile
    # that environment may be imported into the systemd user session
    # that will overwrite any variabls that conflict with environment.d config
    # this will merge the two environments so that they are properly ordered
    environment_d_sourced=""

    for environment_d in /etc/environment.d "''${HOME}/.config/environment.d"; do
        [ -d "$environment_d" ] || continue

        for file in "$environment_d"/*; do
            [ -f "$file" ] || continue

            case ":$environment_d_sourced:" in
                *:"$file":*)
                    continue
                    ;;
            esac

            # shellcheck source=/dev/null
            . "$file"
            environment_d_sourced="''${environment_d_sourced}:$file"
        done
    done
  '';
}
