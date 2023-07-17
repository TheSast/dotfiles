return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-media-files.nvim",
    "jvgrootveld/telescope-zoxide",
    "debugloop/telescope-undo.nvim",
    opts = function(_, opts)
      return require("astronvim.utils").extend_tbl(opts, {
        defaults = {
          winblend = vim.g.neovide and vim.o.winblend,
        },
      })
    end,
  },
  keys = {
    { "<leader>fM", "<cmd>Telescope media_files<CR>", desc = "Find media" },
    { "<leader>fz", "<cmd>Telescope zoxide list<CR>", desc = "Find directories" },
    { "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Find undos" },
  },
  config = function(...)
    require "plugins.configs.telescope"(...)
    local telescope = require "telescope"
    telescope.load_extension "media_files"
    telescope.load_extension "zoxide"
    telescope.load_extension "undo"
  end,
}
