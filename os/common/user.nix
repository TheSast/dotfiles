{config, ...}: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "!";
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
