{ modules, ... }: {
  imports = [
    ../../conditional/graphical.nix
    ../../conditional/preservation.nix

    modules.nixos-hardware.framework-16-amd-ai-300-series
    ./audio.nix
    ./battery.nix
    ./disko.nix
    ./fscrypt.nix
    ./hardware.nix
    ./identity.nix
    ./login-manager.nix
    ./network.nix
    ./preservation.nix
    ./security.nix
    ./secrets.nix
    ./state.nix
  ];

  # TODO: move to common
  # nautilus
  services.gvfs.enable = true;
}
