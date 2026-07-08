{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key.pub".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key.pub".path;}
    ];
  };
  networking.hostName = "kafka";
  system.stateVersion = "23.05"; # WARNING: do not touchy
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      devices = ["nodev"];
      fontSize = 30;
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
    timeout = 10;
  };
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "10m"; # systemd-suspend-then-hibernate delay to hibernation
    HibernateMode = "shutdown";
  };
  systemd.services.fix-button-after-hibernate = {
    # it is needed after terminating (by crashing?) user session and redoing login
    description = "Reload ACPI Button Module After Hibernate";
    after = [
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.kmod}/bin/modprobe -r button"
        "${pkgs.kmod}/bin/modprobe button"
      ];
    };
  };
  services.pipewire.pulse.enable = false;
}
