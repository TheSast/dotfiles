{
  modules,
  pkgs,
  ...
}: {
  imports = [modules.nix-secrets];
  security.nix-secrets = {
    enable = true;
    storage = modules.private.secrets.storage;
    extraPackages = [pkgs.age];
    installPackage = false;
    identityPaths = ["/dur/nixos_age_key_pq_plugin"];
    defaultRecipients = [modules.private.secrets.recipient];
    secrets = modules.private.secrets.namesAsAttrs;
  };
}
