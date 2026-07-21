require("lazy").setup {
  spec = {
    {
      "AstroNvim/AstroNvim",
      version = "6.0.5",
      import = "astronvim.plugins",
      opts = {
        maplocalleader = vim.utils.termcodes "<C-Space>",
      },
    },
    { "AstroNvim/astrocommunity", version = "20.0.0" },
    { import = "plugins" },
  },
  change_detection = { notify = false },
  defaults = { lazy = true },
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
