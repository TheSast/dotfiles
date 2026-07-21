---Mutate an options table by filter the list-like table of lspconfig sources by available binaries, accounting for cmd overrides
---
--- NOTE: This mutates opts!
---@param opts table # Options table with `servers.when_available` table of sources to filter
---@return table avail # The options table with a filtered source list
local f = function(opts)
  return vim.tbl_extend("force", opts or {}, {
    servers = vim.list_extend(
      vim.tbl_get(opts, "servers", "always") or {},
      vim.tbl_filter(
        function(src_name)
          return vim.utils.executable(
            vim.tbl_get(opts, "config", src_name, "cmd", 1)
              or vim.tbl_get(require("lspconfig.configs." .. src_name).default_config, "cmd", 1)
          )
        end,
        vim.tbl_get(opts, "servers", "when_available") or {}
      )
    ),
  })
end

---Eval functions given default configs in config table
---
--- NOTE: This mutates configs!
---@param configs table # The configs table with functions where defaults want to be modified
---@return table ret # The configs table, with the functions evaluated
local config_via_fn = function(configs)
  for src_name, src_config in pairs(configs) do
    if type(src_config) == "function" then
      local default_config = require("lspconfig.configs." .. src_name).default_config
      configs[src_name] = src_config(default_config)
    end
  end
  return configs
end

local override_bin = function(bin)
  return function(default)
    default = default or {}
    default.cmd = default.cmd or {}
    default.cmd[1] = bin
    return default
  end
end

---@type LazySpec
return {
  {
    "astrolsp",
    ---@type AstroLSPOpts
    opts = f {
      features = {
        codelens = true,
        inlay_hints = true,
        semantic_tokens = true,
      },
      -- :h lspconfig-all
      servers = {
        when_available = {
          "bashls",
          "clangd",
          "rust_analyzer", -- only seems to properly load in once InsertLeave is sent, and takes a while for `vim.lsp.buf.hover()` to work
          "marksman",
          "ts_ls",
          "html",
          "htmx",
          -- TODO: check setup doc
          "cssls",
          -- TODO: check setup doc
          -- "jsonls",
          -- TODO: check setup doc
          "yamlls",
          "taplo",
          "tinymist",
          "awk_ls",
          "lemminx",
          "phpactor",
          "gopls",
          "golangci_lint_ls",
          "spyglassmc_language_server",
        },
        always = {
          "lua_ls",
          "nil_ls",
        },
      },
      formatting = {
        disabled = {
          "lua_ls",
        },
      },
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      config = config_via_fn {
        cssls = override_bin "css-languageserver",
        jsonls = override_bin "vscode-json-languageserver",
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              ["hint.arrayIndex"] = false,
            },
          },
        },
        bashls = {
          settings = {
            bashIde = {
              shfmt = {
                ignoreEditorconfig = true,
              },
            },
          },
        },
      },
      mappings = {
        n = {
          ["K"] = false,
          ["gh"] = false,
          ["gK"] = false,
          ["<Leader>lH"] = {
            function() vim.lsp.buf.hover() end,
            desc = "Hover symbol details",
            cond = "textDocument/hover",
          },
          ["gy"] = false,
          ["<Leader>lgy"] = {
            function() vim.lsp.buf.type_definition() end,
            desc = "Definition of current type",
            cond = "textDocument/typeDefinition",
          },
          ["gD"] = false,
          ["<Leader>lgD"] = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["gd"] = false,
          ["<Leader>lgd"] = {
            function() vim.lsp.buf.definition() end,
            desc = "Definition of current symbol",
            cond = "textDocument/definition",
          },
          ["gI"] = false,
          ["<Leader>lgI"] = {
            function() vim.lsp.buf.implementation() end,
            desc = "Implementation of current symbol",
            cond = "textDocument/implementation",
          },
        },
      },
    },
  },
  { import = "plugins.lsp" },
  -- TODO: consider https://github.com/udayvir-singh/tangerine.nvim
  -- TODO: consider https://github.com/Olical/nfnl
  -- TODO: consider https://github.com/Olical/aniseed
  -- TODO: consider https://github.com/Olical/conjure
  -- TODO: consider https://github.com/adigitoleo/overview.nvim
  -- TODO: consider https://github.com/jmbuhr/otter.nvim
}
