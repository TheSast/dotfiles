{config, ...}: {
  home.file.".ssh/config".source = ./ssh/config;
  security.nix-secrets.secrets = {
    "home/ssh/joker/id_ed25519".path = "${config.home.homeDirectory}/.ssh/joker/id_ed25519";
    "home/ssh/joker/id_ed25519.pub".path = "${config.home.homeDirectory}/.ssh/joker/id_ed25519.pub";
    "home/ssh/ren/id_ed25519".path = "${config.home.homeDirectory}/.ssh/ren/id_ed25519";
    "home/ssh/ren/id_ed25519.pub".path = "${config.home.homeDirectory}/.ssh/ren/id_ed25519.pub";
  };
}
