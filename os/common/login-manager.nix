{pkgs, ...}: {
  # ISSUE: graphical session managment is not a fundamentally systemwide endevour
  # the user should be able to declare the session files and the login manager
  # should be the one to query a root-owned per-user config containing said declarations
  services.displayManager.sessionPackages = with pkgs; [
    niri
  ];
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
