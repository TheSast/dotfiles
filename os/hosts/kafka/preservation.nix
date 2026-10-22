{
  preservation.preserveAt."/dur" = {
    directories = [
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
      }
      "/var/lib/fprint"
      "/etc/mullvad-vpn"
    ];
  };
}
