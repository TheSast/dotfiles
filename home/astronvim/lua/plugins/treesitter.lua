---@type LazySpec
return {
  {
    "astrocore",
    -- TODO: move to nix-managed parsers
    opts = {
      treesitter = {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "fish",
          "lua",
          "nix",
          "rust",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
          "json",
          "jsonc",
        },
      },
    },
  },
}
