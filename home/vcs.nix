{
  config,
  pkgs,
  lib,
  ...
}:
let
  symlinkDirectly = (import ../lib.nix).symlinkDirectly config;
in
{
  home.packages = with pkgs; [
    gh
    git
    jjui
    jujutsu
    lazygit
    lazyjj
  ];
  xdg.configFile = {
    "git/config" = {
      source = symlinkDirectly "git/config";
    };
    jj = {
      source = symlinkDirectly "jj";
    };
    lazygit = {
      source = ./lazygit;
    };
    scripts = {
      source = symlinkDirectly "scripts";
    };
    swayimg = {
      source = ./swayimg;
    };
  };
  security.nix-secrets = {
    templates = let
      mkGitIdentity = identity: let
        pathOf = val: config.security.nix-secrets.secrets."home/${identity}-${val}".templateKey;
        name = pathOf "name";
        email = pathOf "email";
        key = pathOf "sshkey";
      in
        # gitconfig
        ''
          [core]
           sshCommand = ssh -i ${key}
          [gpg "ssh"]
           allowedSignersFile = ${key}.pub
          [user]
           email = "${email}"
           name = "${name}"
           signingKey = ${key}.pub
        '';
      mkJjIdentity = identity: let
        pathOf = val: config.security.nix-secrets.secrets."home/${identity}-${val}".templateKey;
        name = pathOf "name";
        email = pathOf "email";
        repos = pathOf "repos";
        key = pathOf "sshkey";
      in
        # repos is formatted as `   "value"` per line, with a comma if it's not the last line
        # toml
        ''
          --when.repositories = [
          ${repos}${lib.optionalString (identity == "jj/conf.d/gh-joker") ",\n  \"~/.config/etc\""}
          ]

          [user]
          name = "${name}"
          email = "${email}"

          [signing]
          key = "${key}.pub"
          backends.ssh.allowed-signers = "${key}.pub"
        '';
    in
      (lib.genAttrs (builtins.map (x: "jj/conf.d/" + x) ["dawn-wine-joker" "gh-joker" "gh-ren" "gl-ren"])
        (
          identity: {
            content = mkJjIdentity identity;
            path = "${config.xdg.configHome}/${identity}.toml";
          }
        ))
      // (
        lib.genAttrs (builtins.map (x: "git/identities/" + x) ["dawn-wine-joker" "gh-joker" "gh-ren" "gl-ren"])
        (
          identity: {
            content = mkGitIdentity identity;
            path = "${config.xdg.configHome}/${identity}";
          }
        )
      );
  };
}
