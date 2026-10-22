{
  pkgs,
  lib ? pkgs.lib,
  isolated,
}: (pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = with pkgs;
    [pkgs.neovim-unwrapped]
    ++ [
      # lsp
      alejandra
      deadnix
      lua-language-server
      luajitPackages.luacheck
      selene
      tinymist
      nil
      statix
      stylua
    ]
    ++ [
      # plugin deps
      gcc # nvim-treesitter
      git # lazy.nvim
      gnumake # jsregexp for LuaSnip
      ripgrep # telescope-fzf-native.nvim # snacks.nvim
      curl # blink.cmp
      fd # snacks.nvim
      tree-sitter # nvim-treeesitter
      # xdg-utils?
      (pkgs.runCommand "picky-coreutils-nvim" {} ''
        mkdir -p "$out/bin"
        ln -s "${pkgs.coreutils}/bin/cat" "$out/bin/cat"
        ln -s "${pkgs.coreutils}/bin/sha256sum" "$out/bin/sha256sum"
      '')
    ];
  text = ''
    export LUA_CPATH="${pkgs.luajitPackages.luautf8}/lib/lua/5.1/?.so;''${LUA_CPATH:-;;}"
    ${
      lib.optionalString isolated
      # sh
      ''
        exec nvim "$@"
      ''
    }
    ${
      lib.optionalString (!isolated)
      # sh
      ''
        exec nvim \
          -u ${./astronvim}/init.lua \
          --cmd "let g:config_dir = '${./astronvim}'" \
          --cmd "set runtimepath+=${./astronvim}/after" \
          "$@"
      ''
    }
  '';
})
