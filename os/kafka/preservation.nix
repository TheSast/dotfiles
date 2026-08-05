{
  preservation = {
    preserveAt."/dur" = {
      files = [
        "/etc/fscrypt.conf"
      ];
      directories = [
        "/.fscrypt"
        "/etc/secureboot"
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
        }
        "/var/lib/fprint"
        "/var/lib/fscrypt"
        {
          directory = "/var/lib/sbctl";
          how = "symlink";
          createLinkTarget = false;
        }
      ];
    };
  };
}
