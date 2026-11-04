{
  preservation.preserveAt."/dur" = {
    directories = [
      "/etc/secureboot"
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
      }
      "/var/lib/fprint"
      "/etc/mullvad-vpn"
      {
        directory = "/var/lib/sbctl";
        how = "symlink";
        createLinkTarget = false;
      }
    ];
  };
}
