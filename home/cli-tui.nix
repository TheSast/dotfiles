{
  flake,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    asciinema
    bat
    broot
    btop
    difftastic
    dust
    erdtree
    eza
    (pkgs.writeShellApplication {
      name = "fetch";
      runtimeInputs = [
        hyfetch
        fastfetch
      ];
      text = ''exec hyfetch -b fastfetch "$@"'';
    })
    fd
    fzf
    glow
    less
    ouch
    ripgrep
    tabiew
    tmux
    zellij
    zoxide
  ];
  xdg.configFile = {
    bat = {
      target = "bat/config";
      text = "--theme=ansi";
    };
    erdtree = {
      source = ./erdtree;
    };
    fastfetch = {
      target = "fastfetch/config.jsonc";
      text = import ./fastfetch.nix {
        inherit
          flake
          ;
      };
    };
    hyfetch = {
      target = "hyfetch.json";
      source = ./hyfetch.json;
    };
    npm = {
      source = ./npm;
    };
    readline = {
      source = ./readline;
    };
    tmux = {
      source = ./tmux;
    };
    tmux-powerline = {
      source = ./tmux-powerline;
    };
  };
}
