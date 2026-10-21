{lib, ...}: {
  networking = {
    mdns.enable = true;
    networkmanager = {
      enable = true;
      ethernet = {
        macAddress = "random";
      };
      wifi = {
        macAddress = "random";
        scanRandMacAddress = true;
      };
    };
  };
  services = {
    openssh = {
      enable = true;
      startWhenNeeded = lib.mkDefault true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64 28 256";
        maxtime = "168h";
        overalljails = true;
      };
    };
  };

  # technically netwroking
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
