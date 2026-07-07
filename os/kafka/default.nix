{
  pkgs,
  config,
  ...
}: {
  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key".path;}
    ];
  };
  networking.hostName = "kafka";
  system.stateVersion = "26.05";
  # there is no way to disable non-hibernation swap and to set swappiness per-swap file/partition
  # this also means zram is hard to make use of
  boot.kernel.sysctl."vm.swappiness" = 0;
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    priority = 100;
  };

  # systemd.network.wait-online.enable = false; # to solve slow boot times, try systemd-analyze plot > slowboot.svg
  # https://github.com/google/fscrypt/issues/405
  systemd.services.greetd.serviceConfig.LimitMEMLOCK = "infinity";
  security = {
    tpm2.enable = true;
    pam = {
      enableFscrypt = true;
    };
  };
  boot = {
    loader.limine = {
      enable = true;
      style = {
        wallpapers = [];
        interface = {
          helpHidden = true;
          branding = "";
        };
      };
      extraConfig = ''
        timeout: 0.25
        quiet: yes
      '';
      secureBoot = {
        autoEnrollKeys.enable = true;
        enable = true;
      };
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
    pipewire.pulse.enable = false;
  };
  systemd = {
    sleep.settings.Sleep = {
      HibernateDelaySec = "10m";
      HibernateMode = "shutdown";
    };
    coredump.settings.Coredump = {
      Storage = "external";
      ProcessSizeMax = "2G";
      ExternalSizeMax = "2G";
      MaxUse = "1G";
      KeepFree = "5G";
    };
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll" &&
        subject.active &&
        subject.local) {
        return polkit.Result.YES;
      }
    });
  '';
  systemd.services."fscrypt-preservation-setup" = {
    description = "set up fscrypt for home encryption by users";
    wantedBy = ["multi-user.target"];
    after = [
      "dur.mount"
      "home.mount"
    ];
    wants = [
      "dur.mount"
      "home.mount"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = with pkgs; [
      util-linux
      fscrypt-experimental
    ];
    script = ''
      set -euo pipefail

      if [ -s /etc/fscrypt.conf ] && [ -n "$(find /.fscrypt -mindepth 1 -print -quit)" ] && [ -e /dur ]; then
        echo "fscrypt is already set up"
        exit 0
      fi

      mountpoint -q /etc/fscrypt.conf && umount /etc/fscrypt.conf
      mountpoint -q /.fscrypt && umount /.fscrypt
      rm /etc/fscrypt.conf
      rmdir /.fscrypt /dur/.fscrypt
      fscrypt setup --all-users
      fscrypt setup /home --all-users
      cp /etc/fscrypt.conf /dur/etc/fscrypt.conf
      cp -a /.fscrypt /dur/.fscrypt
      mount --bind /dur/etc/fscrypt.conf /etc/fscrypt.conf
      mount --bind /dur/.fscrypt /.fscrypt

      echo "fscrypt setup complete"
    '';
  };
}
