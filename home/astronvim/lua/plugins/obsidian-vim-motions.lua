if not vim.g.obsidian then return {} end -- don't do anything in non-obsidian instances

-- Set `vim.notify` to Obsidian notifications
vim.notify = function(msg, level, opts)
  local levels = vim.log.levels
  level = level or levels.INFO
  local prefix = ""

  -- legacy
  if level >= levels.INFO then
    if level == levels.ERROR then
      prefix = "ERR: "
    elseif level == levels.WARN then
      prefix = "WARN: "
    end
    vim.print(prefix .. msg)
  end
end

local enabled = {}
vim.tbl_map(function(plugin) enabled[plugin] = true end, {
  -- core plugins
  "lazy.nvim",
  "AstroNvim",
  "astrocore",
  "astroui",
  "nvim-autopairs",
  "nvim-treesitter",
  "nvim-ts-autotag",
  "nvim-treesitter-textobjects",
  -- more known working
  "obsidian.nvim",
  "plenary.nvim",
  "blink.cmp",
  "LuaSnip",
  "better-escape.nvim",
  "telescope.nvim",
  "dial.nvim",
  "which-key.nvim",
  "flash.nvim",
  "flit.nvim",
  "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-spider",
  "nvim-surround",
  "ts-comments.nvim",
  "vim-easy-align",
  "vim-repeat",
  "vim-sandwich",
  "yanky.nvim",
  -- feel free to open PRs to add more support!
  "improved-ft.nvim",
})

local Config = require "lazy.core.config"
-- disable plugin update checking
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
-- replace the default `cond`
Config.options.defaults.cond = function(plugin) return enabled[plugin.name] end
-- Config.options.defaults.cond = function(plugin) return true end

---@type LazySpec
return {
  -- add a few keybindings
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local opt = vim.tbl_get(opts, "options", "opt")
      if opt then opt.cmdheight = nil end

      local maps = assert(opts.mappings)
      -- zoom
      maps.n["<C-=>"] = function() vim.cmd "Ob window:zoom-in" end
      maps.n["<C-->"] = function() vim.cmd "Ob window:zoom-out" end
      maps.n["<C-0>"] = function() vim.cmd "Ob window:reset-zoom" end

      -- package management
      maps.n["gf"] = function() vim.cmd "Ob editor:follow-link" end
      maps.n["<Leader>p"] = nil
      maps.n["<Leader>ps"] = nil
      maps.n["<Leader>pi"] = nil
      maps.n["<Leader>pa"] = nil
      maps.n["<Leader>pA"] = nil
      maps.n["<Leader>pu"] = nil
      maps.n["<Leader>pU"] = nil
      maps.n["<Leader>pS"] = nil

      -- basic actions
      maps.n["<F1>"] = function() vim.cmd "Ob app:open-help" end
      maps.n["<Leader>q"] = function() vim.cmd "Ob workspace:close" end
      maps.n["<Leader>w"] = function() vim.cmd "Ob editor:save-file" end
      maps.n["<Leader>n"] = function() vim.cmd "Ob file-explorer:new-file" end

      -- splits navigation
      maps.n["\\"] = function() vim.cmd "Ob workspace:split-horizontal" end
      maps.n["|"] = function() vim.cmd "Ob workspace:split-vertical" end
      maps.n["<C-H>|"] = function() vim.cmd "Ob editor:focus-left" end
      maps.n["<C-J>|"] = function() vim.cmd "Ob editor:focus-bottom" end
      maps.n["<C-K>|"] = function() vim.cmd "Ob editor:focus-top" end
      maps.n["<C-L>|"] = function() vim.cmd "Ob editor:focus-right" end
      --
      -- terminal
      --   maps.n["<F7>"] = function() require("obsidian-hypothetical-terminal-plugin").action "toggleTerminal" end
      --   maps.n["<C-'>"] = function() require("obsidian-hypothetical-terminal-plugin").action "toggleTerminal" end
      --
      -- buffer management
      maps.n["]b"] = function() vim.cmd "Ob workspace:next-tab" end
      maps.n["[b"] = function() vim.cmd "Ob workspace:previous-tab" end
      maps.n["<Leader>c"] = nil
      maps.n["<Leader>C"] = nil
      maps.n["<Leader>bc"] = function() vim.cmd "Ob workspace:close-others" end
      maps.n["<Leader>bC"] = nil
      maps.n["<Leader>bp"] = function() vim.cmd "Ob workspace:goto-last-tab" end
      --
      maps.n["<Leader>bb"] = nil
      maps.n["<Leader>bd"] = nil
      maps.n["<Leader>bf"] = nil
      maps.n["<Leader>bl"] = nil
      maps.n["<Leader>bp"] = nil
      maps.n["<Leader>br"] = nil
      maps.n["<Leader>bt"] = nil
      maps.n["<Leader>bse"] = nil
      maps.n["<Leader>bsi"] = nil
      maps.n["<Leader>bsm"] = nil
      maps.n["<Leader>bsp"] = nil
      maps.n["<Leader>bsr"] = nil
      maps.n["<Leader>b\\"] = nil

      -- file explorer
      maps.n["<Leader>e"] = function() vim.cmd "Ob file-explorer:open" end
      maps.n["<Leader>o"] = function() vim.cmd "Ob app:toggle-left-sidebar" end
      --
      --   -- indentation
      --   maps.v["<Tab>"] = function() require("vscode").action "editor.action.indentLines" end
      --   maps.v["<S-Tab>"] = function() require("vscode").action "editor.action.outdentLines" end
      --
      --   -- diagnostics
      --   maps.n["]d"] = function() require("vscode").action "editor.action.marker.nextInFiles" end
      --   maps.n["[d"] = function() require("vscode").action "editor.action.marker.prevInFiles" end
      --
      -- pickers (emulate telescope mappings)
      --   maps.n["<Leader>fc"] = function()
      --     require("vscode").action("workbench.action.findInFiles", { args = { query = vim.fn.expand "<cword>" } })
      --   end
      --   maps.n["<Leader>fC"] = function() require("vscode").action "workbench.action.showCommands" end
      maps.n["<Leader>ff"] = function() vim.cmd "Ob vim-motions:picker-files" end
      --   maps.n["<Leader>fn"] = function() require("vscode").action "notifications.showList" end
      maps.n["<Leader>fo"] = function() vim.cmd "Ob vim-motions:picker-recent" end
      maps.n["<Leader>ft"] = function() vim.cmd "Ob theme:switch" end
      maps.n["<Leader>fw"] = function() vim.cmd "Ob vim-motions:picker-livegrep" end
      maps.n["<Leader>fb"] = function() vim.cmd "Ob vim-motions:picker-buffers" end
      maps.n["<Leader>fr"] = function() vim.cmd "Ob vim-motions:picker-registers" end
      maps.n["<Leader>f'"] = function() vim.cmd "Ob vim-motions:picker-marks" end
      maps.n["<Leader><CR>"] = function() vim.cmd "Ob vim-motions:picker-resume" end
      maps.n["<Leader>fa"] = function() vim.cmd "Ob app:open-settings" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-quickfix" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-tags" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-actions" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-backlinks" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-headings" end
      -- maps.n["<Leader>??"] = function() vim.cmd "Ob vim-motions:picker-outline" end
      --
      --
      maps.n["<Leader>ub"] = function() vim.cmd "Ob theme:toggle-light-dark" end
      maps.n["<Leader>ul"] = nil
      maps.n["<Leader>ur"] = nil
      maps.n["<Leader>uu"] = nil
      maps.n["<Leader>ug"] = nil
      maps.n["<Leader>uy"] = nil
      maps.n["<Leader>uY"] = nil
      maps.n["<Leader>uv"] = nil
      maps.n["<Leader>uV"] = nil
      maps.n["<Leader>us"] = function() vim.cmd "Ob editor:toggle-spellcheck" end
      maps.n["<Leader>uS"] = nil
      maps.n["<Leader>ut"] = nil
      maps.n["<Leader>u>"] = nil
      --
      --   -- git client
      --   maps.n["<Leader>gg"] = function() require("vscode").action "workbench.view.scm" end
      --
      --   -- LSP Mappings
      --   maps.n["K"] = function() require("vscode").action "editor.action.showHover" end
      --   maps.n["gI"] = function() require("vscode").action "editor.action.goToImplementation" end
      --   maps.n["gd"] = function() require("vscode").action "editor.action.revealDefinition" end
      --   maps.n["gD"] = function() require("vscode").action "editor.action.revealDeclaration" end
      --   maps.n["gr"] = function() require("vscode").action "editor.action.goToReferences" end
      --   maps.n["gy"] = function() require("vscode").action "editor.action.goToTypeDefinition" end
      --   maps.n["<Leader>la"] = function() require("vscode").action "editor.action.quickFix" end
      --   maps.n["<Leader>lG"] = function() require("vscode").action "workbench.action.showAllSymbols" end
      --   maps.n["<Leader>lR"] = function() require("vscode").action "editor.action.goToReferences" end
      --   maps.n["<Leader>lr"] = function() require("vscode").action "editor.action.rename" end
      --   maps.n["<Leader>ls"] = function() require("vscode").action "workbench.action.gotoSymbol" end
      --   maps.n["<Leader>lf"] = function() require("vscode").action "editor.action.formatDocument" end
    end,
  },
  -- disable treesitter highlighting
  { "AstroNvim/astrocore", optional = true, opts = { treesitter = { highlight = false } } },
  { "AstroNvim/astroui", optional = true, opts = function(_, opts) opts.colorscheme = nil end },
}
