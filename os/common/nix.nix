{
  nixpkgs = {
    config.allowUnfree = false;
    flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
  nix = {
    channel.enable = false;
    settings = {
      use-registries = false;
      flake-registry = "";
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
      trusted-users = ["@wheel"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    nixPath = [];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
