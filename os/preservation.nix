{inputs, ...}: {
  imports = [
    inputs.preservation.nixosModules.default
  ];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/dur".neededForBoot = true;
  boot.initrd.systemd.suppressedUnits = ["systemd-machine-id-commit.service"];
  systemd.services.systemd-machine-id-commit.unitConfig.ConditionFirstBoot = true;
  boot.tmp.cleanOnBoot = true;
  preservation = {
    enable = true;

    preserveAt."/dur" = {
      files = [
        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
        }
        "/etc/machine-id"
      ];
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/bluetooth"
        "/var/lib/AccountsService"
        "/var/lib/bluetooth"
        "/var/lib/disko"
        "/var/lib/fwupd"
        "/var/lib/udisks2"
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
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    journald.extraConfig = ''
      SystemMaxUse=1G
      RuntimeMaxUse=200M
    '';
  };
  systemd = {
    coredump.settings.Coredump = {
      Storage = "external";
      ProcessSizeMax = "2G";
      ExternalSizeMax = "2G";
      MaxUse = "1G";
      KeepFree = "5G";
    };
  };
}
