local obsidian_note_callback = function(_)
  -- HACK: require("obsidian").get_client():path_is_note(..., nil) seems to always return true for md files, manually check for .obsidian in parent dirs of buffer
  if not vim.fs.root(0, ".obsidian") then return end
  vim.opt_local.conceallevel = 1

  if require("astrocore").is_available "which-key.nvim" then
    require("which-key").add {
      { "<Leader>o", desc = "󱓧 Obsidian", buffer = true },
      {
        "gf",
        function() return require("obsidian").util.gf_passthrough() end,
        noremap = false,
        expr = true,
        buffer = true,
        desc = "Go to file under cursor",
      },
      {
        "<leader>oc",
        function() return require("obsidian").util.toggle_checkbox() end,
        buffer = true,
        desc = "toggle checkbox",
      },
      {
        "<leader>of",
        -- function() return vim.cmd "Obsidian quick_switch" end,
        function() return vim.cmd "ObsidianQuickSwitch" end,
        buffer = true,
        desc = "find documents",
      },
      {
        "<leader>oo",
        -- function() return vim.cmd "Obsidian open" end,
        function() return vim.cmd "ObsidianOpen" end,
        buffer = true,
        desc = "open current document in obsidian",
      },
      {
        "<leader>ot",
        function()
          vim.g.obsidian_note_autosave = ({
            InsertLeave = "off",
            TextChanged = "InsertLeave",
            off = "TextChanged",
          })[vim.g.obsidian_note_autosave] or "off"
          vim.notify("obsidian note autosave " .. vim.g.obsidian_note_autosave)
        end,
        buffer = true,
        desc = "toggle obsidian note autosave",
      },
    }
  end

  vim.api.nvim_create_autocmd({
    "TextChanged",
    "TextChangedI",
  }, {
    buffer = 0,
    callback = function()
      if vim.g.obsidian_note_autosave == "TextChanged" then vim.cmd "silent! write" end
    end,
  })

  vim.api.nvim_create_autocmd({
    "InsertLeave",
  }, {
    buffer = 0,
    callback = function()
      if vim.g.obsidian_note_autosave == "InsertLeave" then vim.cmd "silent! write" end
    end,
  })
end
---@type LazySpec
return {
  {
    "monkoose/matchparen.nvim",
    event = "User AstroFile",
    opts = {},
  },
  {
    "luckasRanarison/nvim-devdocs",
    enabled = false,
    lazy = false,
    dependencies = {
      "plenary.nvim",
      "telescope.nvim",
      {
        "nvim-treesitter/nvim-treesitter",
        opts = { -- ISSUE: https://discord.com/channels/939594913560031363/1155519593008341095/1207783682434408470
          ensure_installed = {
            "html",
          },
        },
      },
    },
    opts = {
      previewer_cmd = "glow", -- TODO: add as dep in home.nix
      cmd_args = { "-w", "80" },
      picker_cmd = "glow",
      picker_cmd_args = { "-w", "50" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = { "plenary.nvim", "nvim-telescope/telescope.nvim" },
    init = function() vim.g.obsidian_note_autosave = "InsertLeave" end,
    opts = {
      disable_frontmatter = true,
      workspaces = {
        {
          name = "auto",
          path = function() return vim.fs.root(0, ".obsidian") or "~/Desktop/" end,
        },
      },
      mappings = {},
      callbacks = {
        enter_note = obsidian_note_callback,
        post_set_workspace = obsidian_note_callback,
      },
    },
  },
}
-- TODO: consider nvim-lightbulb
-- TODO: consider vim-radical or more maintained alternatives
-- TODO: consider vim-case-changer or more maintained alternatives
-- TODO: consider https://github.com/iamcco/markdown-preview.nvim (maybe-lang?)
-- TODO: consider neogen
-- TODO: consider undotree
-- TODO: consider https://github.com/nanotee/zoxide.vim
-- TODO: consider https://github.com/ecthelionvi/NeoComposer.nvim
-- TODO: consider https://github.com/chrisgrieser/nvim-rip-substitute
-- TODO: consider https://github.com/chrisgrieser/ THERE ARE SO MANY
-- e.g.
--https://github.com/chrisgrieser/nvim-scissors
--https://github.com/chrisgrieser/nvim-tinygit
-- TODO: consider https://github.com/gbprod/yanky.nvim
-- TODO: consider https://github.com/MagicDuck/grug-far.nvim
--https://github.com/backdround/improved-search.nvim
--https://github.com/andrep/vimacs
