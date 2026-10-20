require("lazy").setup {
  spec = {
    {
      "AstroNvim/AstroNvim",
      version = "6.1.1",
      import = "astronvim.plugins",
      opts = {
        maplocalleader = vim.utils.termcodes "<C-Space>",
      },
    },
    { "AstroNvim/astrocommunity", commit = "d79a4b5" },
    { import = "plugins" },
  },
  change_detection = { notify = false },
  defaults = { lazy = true, version = "*" },
  install = { colorscheme = { "astrotheme", "habamax" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit", -- see `:h cpo-%`
        "matchparen",
        "netrwPlugin",
        -- "rplugin",
        -- "shada",
        -- "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
