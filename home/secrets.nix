{
  config,
  modules,
  pkgs,
  lib,
  ...
}: {
  imports = [modules.nix-secrets];
  security.nix-secrets = {
    enable = true;
    storage = modules.private.secrets.storage;
    extraPackages = [pkgs.age];
    installPackage = false;
    identityPaths = ["${config.xdg.configHome}/age/home_age_key_pq_plugin"];
    defaultRecipients = [modules.private.secrets.recipient];
    defaultGroup = "users";
    secrets = modules.private.secrets.namesAsAttrs;
  };
  systemd.user.services.nix-secrets-activate.Service.Environment = [("PATH=" + lib.makeBinPath config.security.nix-secrets.extraPackages)];
}
