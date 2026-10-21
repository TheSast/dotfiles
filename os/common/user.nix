{config, ...}: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.age.secrets.root-hashed-password.path;
      };
      u = {
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets.u-hashed-password.path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
        ];
      };
    };
  };
}
