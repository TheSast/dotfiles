---@type LazySpec
return {
  {
    "nvim-lspconfig",
    init = function(_)
      for _, method in ipairs { "textDocument/diagnostic", "workspace/diagnostic" } do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then return end
          return default_diagnostic_handler(err, result, context, config)
        end
      end
    end,
  },
  {
    "astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                locationLinks = { enable = true },
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                discriminatingHints = { enable = true },
                expressionAdjustmentHints = { always = true },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "always" },
              },
            },
          },
        },
      },
    },
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        on_attach = function(...) require("astrolsp").on_attach(...) end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
