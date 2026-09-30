return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      if vim.fn.has("nvim-0.11") == 0 then
        vim.notify("lsp.lua: потрібен Neovim 0.11+", vim.log.levels.ERROR)
        return
      end

      vim.lsp.set_log_level("off")

      vim.o.winborder = "rounded"

      local ts_hints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { disable = { "missing-fields" } },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              hint = { enable = false },
            },
          },
        },

        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--background-index-priority=low",
            "-j=" .. math.max(1, math.floor((vim.uv.available_parallelism() or 4) / 2)),
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--all-scopes-completion",
            "--pch-storage=memory",
            "--fallback-style=llvm",
          },
          init_options = { clangdFileStatus = true },
        },

        ts_ls = {
          settings = {
            typescript = { inlayHints = ts_hints },
            javascript = { inlayHints = ts_hints },
          },
        },

        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },

        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              -- cargo = { allFeatures = true },
            },
          },
        },

        csharp_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        bashls = {},
        dockerls = {},
        phpactor = {},
        julials = {},
      }

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      vim.lsp.config("*", { capabilities = capabilities })

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      })
      vim.lsp.enable(vim.tbl_keys(servers))

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "definition")
          map("n", "gD", vim.lsp.buf.declaration, "declaration")
          map("n", "gi", vim.lsp.buf.implementation, "implementation")
          map("n", "gt", vim.lsp.buf.type_definition, "type definition")
          map("n", "gr", vim.lsp.buf.references, "references")
          map("n", "K", vim.lsp.buf.hover, "hover")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "signature help")
          map("n", "<leader>rn", vim.lsp.buf.rename, "rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "format")
          map("n", "<leader>ds", vim.lsp.buf.document_symbol, "document symbols")
          map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "workspace symbols")

          if client and client:supports_method("textDocument/inlayHint") then
            map("n", "<leader>th", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
            end, "toggle inlay hints")
          end
        end,
      })

      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

      vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
        float = { source = true },
      })
    end,
  },
}
