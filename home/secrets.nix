{
  config,
  modules,
  ...
}: {
  imports = [
    modules.agenix
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
      "jj/conf.d/gh-joker" = {
        file = ./jj/conf.d/gh-joker.toml.age;
        path = "$XDG_CONFIG_HOME/jj/conf.d/gh-joker.toml";
      };
      "jj/conf.d/gh-ren" = {
        file = ./jj/conf.d/gh-ren.toml.age;
        path = "$XDG_CONFIG_HOME/jj/conf.d/gh-ren.toml";
      };
      "jj/conf.d/gl-ren" = {
        file = ./jj/conf.d/gl-ren.toml.age;
        path = "$XDG_CONFIG_HOME/jj/conf.d/gl-ren.toml";
      };
    };
  };
}
