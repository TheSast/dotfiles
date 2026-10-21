{pkgs, ...}: {
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandlePowerKey = "ignore";
    HandleRebootKey = "ignore";
    HandleRebootKeyLongPress = "ignore";
    HandleSuspendKey = "ignore";
    HandleSuspendKeyLongPress = "ignore";
    HandleHibernateKey = "ignore";
    HandleHibernateKeyLongPress = "ignore";
  };
  # FIXME: move to user config
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];
  services.udisks2.enable = true;
  hardware.graphics.enable = true;
}
