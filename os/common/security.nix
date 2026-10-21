{config, ...}: {
  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id.indexOf("org.nixos") == 0) {
            polkit.log("Caching admin authentication for single NixOS operation");
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
    sudo.enable = false;
    wrappers = {
      su.enable = false;
      sudoedit.enable = false;
      sg.enable = false;
      # fusermount.enable = false; # may break appimages?
      # fusermount3.enable = false; # may break appimages?
      pkexec3.enable = false;
      newgpr.enable = false;
      chsh.enable = config.users.mutableUsers;
    };
  };
}
