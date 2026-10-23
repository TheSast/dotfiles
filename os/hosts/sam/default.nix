{
  imports = [
    ./sshd.nix
    ./wsl
  ];
  services.opensshServer = {
    # should enable Doman and Public on "OpenSSH SHH Server (sshd)" in the "Windows Defender Firewall with Advanced Security"
    enable = true;
    startupType = "automatic";
  };
  winget.packages = [
    "Seelen.SeelenUI"
    "Valve.Steam"
  ];
  windows.gaming.hardwareAcceleratedScheduling = true;
}
