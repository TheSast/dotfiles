{ pkgs, ... }: {
  nix = {
    settings.use-registries = false;
    settings.flake-registry = "";
    keepOldNixPath = false;
    nixPath = [ ];
  };
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true; # affects home.profileDirectory
    };
    package = pkgs.nix;
  };
}
