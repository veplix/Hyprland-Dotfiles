return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      local mlsp = require("mason-lspconfig")
      mlsp.setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "lua_ls",
          "clangd",
          "csharp_ls",
          "rust_analyzer",
          "html",
          "cssls",
          "jsonls",
          "bashls",
          "dockerls",
          "phpactor",
          "julials",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lsp = vim.lsp

      lsp.config.lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      }

      local servers = {
        "pyright",
        "tsserver",
        "lua_ls",
        "clangd",
        "csharp_ls",
        "rust_analyzer",
        "html",
        "cssls",
        "jsonls",
        "bashls",
        "dockerls",
        "phpactor",
        "solargraph",
        "julials",
      }

      for _, server in ipairs(servers) do
        local ok, _ = pcall(lsp.enable, server)
        if not ok then
          vim.notify("Failed to enable LSP: " .. server, vim.log.levels.WARN)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local opts = { buffer = buf, remap = false }
          vim.keymap.set("n", "gd", lsp.buf.definition, opts)
          vim.keymap.set("n", "K", lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>f", function()
            lsp.buf.format({ async = true })
          end, opts)
        end,
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
    end,
  },
}
