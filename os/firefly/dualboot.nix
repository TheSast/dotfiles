{pkgs, ...}: let
  rebootIntoNTMode = pkgs.writeShellApplication {
    name = "reboot-into-nt-mode";

    runtimeInputs = [
      pkgs.efibootmgr
      pkgs.gnused
    ];

    text = ''
      set -eu

      bootnum=$(
        efibootmgr |
          sed -n 's/^Boot\([0-9A-Fa-f]\{4\}\).*Windows Boot Manager.*/\1/p' |
          head -n1
      )

      if [ -z "$bootnum" ]; then
        echo "error: Windows Boot Manager not found" >&2
        exit 1
      fi

      echo "Setting Windows Boot Manager (Boot$bootnum) as next boot..."

      efibootmgr --bootnext "$bootnum"
      systemctl reboot
    '';
  };
in {
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "reboot-into-nt-mode.service" &&
        action.lookup("verb") == "start" &&
        subject.isInGroup("wheel")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  systemd.services.reboot-into-nt-mode = {
    description = "Reboot into NT mode on the next boot";

    # Prevent concurrent invocations
    unitConfig = {
      RefuseManualStop = true;
    };

    serviceConfig = {
      Type = "oneshot";

      ExecStart = "${rebootIntoNTMode}/bin/reboot-into-nt-mode";

      RemainAfterExit = false;
    };
  };
}
