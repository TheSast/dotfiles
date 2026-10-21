{
  lib,
  config,
  ...
}: let
  cfg = config.networking.mdns;
in {
  options.networking.mdns = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable advertisement and resolution via multicast DNS";
    };

    autoAdvertise = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Advertise hostname via multicast DNS by default.
        This option is not recommended for mobile devices, it is recommended set the related per-link option for mdns in NetworkManager instead.'';
    };
  };

  config = lib.mkIf cfg.enable {
    services.resolved = {
      enable = true;
      settings.Resolve.MulticastDNS = "yes";
    };

    networking = {
      networkmanager = {
        enable = true;
        connectionConfig.mdns =
          if cfg.autoAdvertise
          then 2
          else null;
      };
      firewall.allowedUDPPorts = [5353];
    };
  };
}
