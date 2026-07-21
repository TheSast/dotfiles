---@type LazySpec
return {
  {
    -- TODO: open an issue to make it possible to configure whether a motion is current and/or target inclusive/exclusive
    "chrisgrieser/nvim-spider",
    opts = {
      consistentOperatorPending = true,
    },
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        opts = {
          rocks = { "luautf8" },
        },
      },
      {
        "astrocore",
        ---@type AstroCoreOpts
        opts = {
          -- IDEA: add a `w` version that counts kebab-cased and pascalCased delimited words as one
          mappings = {
            [""] = {
              ["<Plug>(spider-w)"] = { function() require("spider").motion "w" end, desc = "Next word" },
              ["<Plug>(spider-e)"] = { function() require("spider").motion "e" end, desc = "Next end of word" },
              ["<Plug>(spider-b)"] = { function() require("spider").motion "b" end, desc = "Previous word" },
              ["<Plug>(spider-ge)"] = { function() require("spider").motion "ge" end, desc = "Previous end of word" },
              ["w"] = { "<Plug>(spider-w)", desc = "Next word" },
              ["e"] = { "<Plug>(spider-e)", desc = "Next end of word" },
              ["b"] = { "<Plug>(spider-b)", desc = "Previous word" },
              ["x"] = { "<Plug>(spider-ge)", desc = "Previous end of word" },
            },
          },
        },
      },
    },
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "User AstroFile",
    opts = {
      safe_labels = {},
      case_sensitive = true,
      keys = {
        next_target = ";", -- does not overrwite the mapping
        prev_target = ",", -- outside this "LEAP" mode
        next_group = "<NOP>",
        prev_group = "<NOP>",
      },
    },
    init = function() vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) end,
    dependencies = {
      {
        "tpope/vim-repeat",
        enable = false, -- the issues with the plugin are not worth the benefits
        -- ISSUE: maps `.`, `u`, `U`, `<C-r>` at the time of loading
      },
      {
        "astrocore",
        ---@type AstroCoreOpts
        opts = {
          mappings = {
            [""] = {
              ["s"] = { "<Plug>(leap-forward)", desc = "Leap forward to" },
              ["S"] = { "<Plug>(leap-backward)", desc = "Leap backward to" },
            },
            n = {
              ["s"] = false,
              ["S"] = false,
            },
            x = {
              ["s"] = false,
              ["S"] = false,
            },
          },
        },
      },
    },
  },
  {
    -- {[{
    -- NOTE: does not create surroundings text objects, e.g. in `cY2}]` `2}` is handled in a custom way, as are each of the operators in opts.mappings
    -- NOTE: will not implement {count1}{operator}{count2}{motion|textobj}
    -- ISSUE: does not handle registers, unable to be used with "{register} (even "_)
    -- ISSUE: does not allow to unset default surroundings
    "mini.surround",
    event = "User AstroFile",
    opts = {
      mappings = {
        add = "Y",
        delete = "DY",
        find = "]Y", -- ISSUE: not mapped in visual mode
        find_left = "[Y", -- ^
        highlight = "",
        replace = "CY",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      respect_selection_type = true,
      n_lines = math.huge,
      silent = true,
    },
    dependencies = {
      "astrocore",
      opts = function(_, opts) opts.mappings.n["gz"] = false end,
    },
  },
  {
    "echasnovski/mini.ai",
    event = "User AstroFile",
    opts = {
      custom_textobjects = {
        [" "] = false,
        ["!"] = false,
        ["#"] = false,
        ["%"] = false,
        ["&"] = false,
        ["'"] = false,
        ["("] = false,
        [")"] = false,
        ["*"] = false,
        ["+"] = false,
        [","] = false,
        ["-"] = false,
        ["."] = false,
        ["/"] = false,
        [":"] = false,
        [";"] = false,
        ["<"] = false,
        ["<Tab>"] = false,
        ["="] = false,
        [">"] = false,
        ["@"] = false,
        ["["] = false,
        ["\\"] = false,
        ["]"] = false,
        ["^"] = false,
        ["_"] = false,
        ["`"] = false,
        ["a"] = false,
        ["b"] = false,
        ["f"] = false,
        ["q"] = false,
        ["t"] = false,
        ["{"] = false,
        ["}"] = false,
        ["~"] = false,
        ['"'] = false,
        ["1"] = false,
        ["2"] = false,
        ["3"] = false,
        ["4"] = false,
        ["5"] = false,
        ["6"] = false,
        ["7"] = false,
        ["8"] = false,
        ["9"] = false,
        ["0"] = false,
        -- should all all %d %p %s keys
      },
      mappings = {
        around_next = "",
        inside_next = "",
        around_last = "",
        inside_last = "",
        goto_left = "",
        goto_right = "",
      },
      n_lines = math.huge,
      -- 'cover', 'cover_or_next', 'cover_or_prev', 'cover_or_nearest', 'next', 'prev', 'nearest'.
      search_method = "cover_or_next",
      silent = true,
    },
  },
  {
    -- ISSUE: f{diagraph} and `:lmap` is unsupported
    "backdround/improved-ft.nvim",
    event = "User AstroFile",
    opts = {
      use_relative_repetition = true,
      use_relative_repetition_offsets = true,
    },
    dependencies = {
      "astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          [""] = {
            -- TODO: add desc?
            ["f"] = { function() return require("improved-ft").hop_forward_to_char() end, expr = true },
            ["F"] = { function() return require("improved-ft").hop_backward_to_char() end, expr = true },
            ["t"] = { function() return require("improved-ft").hop_forward_to_pre_char() end, expr = true },
            ["T"] = { function() return require("improved-ft").hop_backward_to_pre_char() end, expr = true },
            [";"] = { function() return require("improved-ft").repeat_forward() end, expr = true },
            [","] = { function() return require("improved-ft").repeat_backward() end, expr = true },
          },
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    opts = {
      forwardLooking = {
        small = math.huge, -- infinite
        big = math.huge, -- seeking
      },
    },
    dependencies = {
      "astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          -- ISSUE: count is unsupported
          o = {
            ["iw"] = { "<Cmd>lua require('various-textobjs').subword('inner')<CR>", desc = "inner Subword" },
            ["aw"] = { "<Cmd>lua require('various-textobjs').subword('outer')<CR>", desc = "outer Subword" },
            ["i<C-Space>"] = {
              "<Cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",
              desc = "inner line",
            },
            ["a<C-Space>"] = {
              "<Cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>",
              desc = "outer line",
            },
            ["in"] = { "<Cmd>lua require('various-textobjs').number('inner')<CR>", desc = "inner number" },
            ["an"] = { "<Cmd>lua require('various-textobjs').number('outer')<CR>", desc = "outer number" },
            ["gG"] = { "<Cmd>lua require('various-textobjs').entireBuffer()<CR>", desc = "Entire buffer" },
          },
          x = {
            ["iw"] = { "<Cmd>lua require('various-textobjs').subword('inner')<CR>", desc = "inner Subword" },
            ["aw"] = { "<Cmd>lua require('various-textobjs').subword('outer')<CR>", desc = "outer Subword" },
            ["i<C-Space>"] = {
              "<Cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",
              desc = "inner line",
            },
            ["a<C-Space>"] = {
              "<Cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>",
              desc = "outer line",
            },
            ["in"] = { "<Cmd>lua require('various-textobjs').number('inner')<CR>", desc = "inner number" },
            ["an"] = { "<Cmd>lua require('various-textobjs').number('outer')<CR>", desc = "outer number" },
            ["gG"] = { "<Cmd>lua require('various-textobjs').entireBuffer()<CR>", desc = "Entire buffer" },
          },
        },
      },
    },
  },
  -- TODO: https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
  -- after tyring *all* of the available multiple cursor plugins, it is clear none can match helix's implementation
}
-- TODO: fix % to not check comments
-- TODO: remove default % (#if #endif), consider https://github.com/theHamsta/nvim-treesitter-pairs https://github.com/andymass/vim-matchup
-- TODO: add a WINDOW_MANAGEMENT mode using hydra.nvim
-- TODO: consider antipatterns https://news.ycombinator.com/item?id=12643887
-- TODO: add iz and az textobj https://github.com/kana/vim-textobj-fold ?
-- xnoremap iz <Cmd>silent!normal![zjV]z<CR>
-- onoremap iz <Cmd>normal viz<CR>
-- xnoremap az <Cmd>silent!normal![zV]zj<CR>
-- onoremap az <Cmd>normal vaz<CR>
-- TODO: consider https://github.com/XXiaoA/ns-textobject.nvim
-- TODO: consider https://github.com/chaoren/vim-wordmotion
