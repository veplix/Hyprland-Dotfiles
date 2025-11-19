return {
  { "neovim/nvim-lspconfig", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "folke/lazydev.nvim", enabled = false },
  { "rcarriga/nvim-dap-ui", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- ✔ Вмикаємо твою нову LSP систему з нуля
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        tsserver = {},
        html = {},
        cssls = {},
        jsonls = {},
        pyright = {},
        clangd = {},
      }

      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        local config = vim.lsp.config(name, opts)
        vim.lsp.start(config)
      end
    end,
  },
}

