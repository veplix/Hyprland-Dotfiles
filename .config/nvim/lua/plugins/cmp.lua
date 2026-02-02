return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          }),
        },



        formatting = {
          fields = { "abbr", "kind" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              if entry.completion_item.documentation then
                local doc = entry.completion_item.documentation
                if type(doc) == "table" and doc.value then
                  local cleaned = doc.value:match("^([^\n]*)")
                  if cleaned and #cleaned > 0 then
                    entry.completion_item.documentation = {
                      kind = doc.kind,
                      value = cleaned
                    }
                  end
                end
              end
              return vim_item
            end,
          }),
        },

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        mapping = cmp.mapping.preset.insert({

          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          }),

          ["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
            end
            fallback()
          end, { "i", "s" }),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),

        completion = {
          completeopt = "menu,menuone,noselect",
        },

        experimental = {
          ghost_text = false,
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline({
          ["<Down>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<Up>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<Tab>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<S-Tab>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<CR>"] = { c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }) },
        }),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Down>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<Up>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<Tab>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<S-Tab>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
          ["<CR>"] = {
            c = function(fallback)
              if cmp.visible() and cmp.get_selected_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
              else
                fallback()
              end
            end,
          },
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({})

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
}
