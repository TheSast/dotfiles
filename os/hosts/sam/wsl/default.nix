{
  wsl = {
    enable = true;
    modules = [
      ./state.nix
      ./network.nix
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
}
