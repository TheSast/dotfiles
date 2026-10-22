{
  config,
  pkgs,
  ...
}:
{
  home.file = {
    ".bash_profile" = {
      source = ./bash/login.bash;
    };
    ".bashrc" = {
      text = import ./bash/nonlogin.nix { inherit pkgs; };
    };
  };

  xdg.configFile.starship.source = ./starship;

  # aka home.shellVariables
  home.sessionVariables = {
    HISTCONTROL = builtins.concatStringsSep ":" config.programs.bash.historyControl;
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    MANPAGER = "less -R --use-color -Dd+r -Du+b";
    MANROFFOPT = "-P -c";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship/starship.toml";
    EDITOR = config.home.sessionVariables.VISUAL;
    inherit (config.systemd.user.sessionVariables) VISUAL;
  };
}
