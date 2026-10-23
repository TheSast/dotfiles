{
  imports = [
    ./sshd.nix
    ./wsl.nix
  ];
  # should enable Doman and Public on "OpenSSH SHH Server (sshd)" in the "Windows Defender Firewall with Advanced Security"
  services.opensshServer.enable = true;
  services.opensshServer.startupType = "automatic";
  # system.stateVersion = "26.05";
  winget.packages = [
    "Seelen.SeelenUI"
    "Valve.Steam"
  ];
  wsl = {
    enable = true;
    modules = [
      {system.stateVersion = "26.05";}
      {
        services.openssh = {
          enable = true;
          ports = [2222];
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
          };
        };
      }
      ({pkgs, ...}: {
        # HACK: https://github.com/nix-community/NixOS-WSL/issues/1100
        systemd.services."wsl-mnt-guard" = {
          overrideStrategy = "asDropin";
          serviceConfig = {
            ExecStart = [
              ""
              "${pkgs.coreutils}/bin/true"
            ];
            ExecStop = [
              ""
              "-${pkgs.util-linux}/bin/mount --make-rslave /mnt/wsl"
            ];
          };
        };
      })
    ];
    defaultUser = "u";
    openFirewall = true;
    networkingMode = "Mirrored";
  };
  windows.gaming.hardwareAcceleratedScheduling = true;
}
