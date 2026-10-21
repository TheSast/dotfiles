{
  modules,
  pkgs,
  config,
  ...
}: {
  imports = [
    modules.preservation
  ];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/dur".neededForBoot = true;
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
      ];
      directories = [
        "/etc/NetworkManager/system-connections"
        # TODO:
        # manual certificate storage, maybe move to networking.networkmanager.ensureProfiles.profiles with agenix?
        # otherwise create a nixos-nm-certs-tool to add/remove/update network certs (to this folder)
        "/etc/NetworkManager/certs"
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
    journald = let
      journalSettings =
        if pkgs.lib.versionAtLeast config.system.nixos.release "26.11"
        then {
          settings.Journal = {
            SystemMaxUse = "1G";
            RuntimeMaxUse = "200M";
          };
        }
        else {
          extraConfig = ''
            SystemMaxUse=1G
            RuntimeMaxUse=200M
          '';
        };
    in
      journalSettings;
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
