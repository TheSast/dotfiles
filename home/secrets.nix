{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  age = {
    identityPaths = ["${config.xdg.configHome}/age/home_age_key"];
    secrets = {
      "ssh/joker/id_ed25519" = {
        file = ./ssh/joker/id_ed25519.age;
        path = "$HOME/.ssh/joker/id_ed25519";
      };
      "ssh/joker/id_ed25519.pub" = {
        file = ./ssh/joker/id_ed25519.pub.age;
        path = "$HOME/.ssh/joker/id_ed25519.pub";
      };
      "ssh/ren/id_ed25519" = {
        file = ./ssh/ren/id_ed25519.age;
        path = "$HOME/.ssh/ren/id_ed25519";
      };
      "ssh/ren/id_ed25519.pub" = {
        file = ./ssh/ren/id_ed25519.pub.age;
        path = "$HOME/.ssh/ren/id_ed25519.pub";
      };
      "git/identities/gh-joker" = {
        file = ./git/identities/gh-joker.age;
        path = "$XDG_CONFIG_HOME/git/identities/gh-joker";
      };
      "git/identities/gh-ren" = {
        file = ./git/identities/gh-ren.age;
        path = "$XDG_CONFIG_HOME/git/identities/gh-ren";
      };
      "git/identities/gl-ren" = {
        file = ./git/identities/gl-ren.age;
        path = "$XDG_CONFIG_HOME/git/identities/gl-ren";
      };
    };
  };
}
