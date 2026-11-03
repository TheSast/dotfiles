{config, ...}: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "!";
      };
      u = {
        isNormalUser = true;
        hashedPasswordFile = config.security.nix-secrets.secrets."os/common/u-hashed-password".path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
        ];
      };
    };
  };
  security.nix-secrets.secrets."os/common/u-hashed-password".neededForUsers = true;
}
