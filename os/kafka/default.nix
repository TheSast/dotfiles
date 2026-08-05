{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disko.nix
    ../preservation.nix
    ./preservation.nix
    ./fscrypt.nix
  ];

  # system identity

  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key".path;}
    ];
  };
  networking.hostName = "kafka";
  system.stateVersion = "26.05";

  # other

  # there is no way to disable non-hibernation swap and to set swappiness per-swap file/partition
  # this also means zram is hard to make use of
  boot.kernel.sysctl."vm.swappiness" = 0;
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    priority = 100;
  };
  services.pipewire.pulse.enable = false;
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "10m";
    HibernateMode = "shutdown";
  };
  services.upower.enable = true;

  # kdeconnect
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  # security

  # tpm2
  security.tpm2.enable = true;
  # secureboot
  boot.loader.limine.secureBoot = {
    autoEnrollKeys.enable = true;
    enable = true;
  };
  # fprint
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll" &&
        subject.active &&
        subject.local) {
        return polkit.Result.YES;
      }
    });
  '';
}
