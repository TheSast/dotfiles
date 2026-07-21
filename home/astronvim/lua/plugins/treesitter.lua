---@type LazySpec
return {
  {
    "nvim-treesitter",
    -- TODO: move to nix-managed parsers
    opts = {
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
}
