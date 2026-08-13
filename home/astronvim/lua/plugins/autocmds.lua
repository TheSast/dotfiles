---@type LazySpec
return {
  "astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      ["spell-files"] = {
        {
          event = "FileType",
          pattern = { "gitcommit", "markdown", "text", "plaintex" },
          desc = "Text like documents enable wrap and spell",
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end,
        },
      },
      easy_help = {
        {
          event = "FileType",
          pattern = "help",
          callback = function() vim.keymap.set("n", "<CR>", "<C-]>", { buffer = true }) end,
        },
      },
      -- TODO: add auto opt.background! possibly using https://github.com/luxus/colorful-times-nvim or https://github.com/f-person/auto-dark-mode.nvim and https://askubuntu.com/questions/22313/what-is-dconf-what-is-its-function-and-how-do-i-use-it
    },
  },
}
-- TODO: add auto opt_local.spelllang!
