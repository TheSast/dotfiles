{
  services.pipewire.pulse.enable = false;

  # INFO: https://github.com/NixOS/nixos-hardware/issues/1743
  # services.pipewire.wireplumber.extraConfig."alsa-framework-16-soft-mixer" = {
  #   "monitor.alsa.rules" = [
  #     {
  #       matches = [
  #         {
  #           "device.name" = "alsa_card.pci-0000_c1_00.6";
  #         }
  #       ];
  #       actions = {
  #         update-props = {
  #           "api.alsa.soft-mixer" = true;
  #         };
  #       };
  #     }
  #   ];
  # };
  environment.etc."wireplumber/wireplumber.conf.d/alsa-framework-16-soft-mixer.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.pci-0000_c1_00.6"
          }
        ]
        actions = {
          update-props = {
            api.alsa.soft-mixer = true
          }
        }
      }
    ]
  ''; # ISSUE: audio is sometimes stuck at 0 until you re-enable and re-disable the hardware mixer
}
