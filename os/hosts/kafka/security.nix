{pkgs, ...}: {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  security.tpm2.enable = true;

  boot.loader.limine.secureBoot = {
    autoEnrollKeys.enable = true;
    enable = true;
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
}
