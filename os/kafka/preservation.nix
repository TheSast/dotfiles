{
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/dur".neededForBoot = true;
  boot.initrd.systemd.suppressedUnits = ["systemd-machine-id-commit.service"];
  systemd.services.systemd-machine-id-commit.unitConfig.ConditionFirstBoot = true;
  boot.tmp.cleanOnBoot = true;
  preservation = {
    enable = true;

    preserveAt."/dur" = {
      files = [
        "/etc/fscrypt.conf"
        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
        }
        "/etc/machine-id"
      ];
      directories = [
        "/.fscrypt"
        "/etc/NetworkManager/system-connections"
        "/etc/bluetooth"
        "/etc/secureboot"
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
        }
        "/var/lib/AccountsService"
        "/var/lib/bluetooth"
        "/var/lib/disko"
        "/var/lib/fprint"
        "/var/lib/fscrypt"
        "/var/lib/fwupd"
        "/var/lib/udisks2"
        {
          directory = "/var/lib/sbctl";
          how = "symlink";
          createLinkTarget = false;
        }
        {
          directory = "/var/lib/nixos";
          inInitrd = true; # probably unnecessary?
        }
        "/var/lib/NetworkManager"
        "/var/lib/systemd/backlight"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
      ];
    };
  };
}
