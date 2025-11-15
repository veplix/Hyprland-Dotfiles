-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/playground", -- optional, helpful for debugging queries
    },
    config = function()
      -- Ensure the installer uses gcc (your mingw64)
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok and install then
        install.compilers = { "gcc" } -- force mingw64 gcc on Windows
        install.prefer_git = false
      end

      require("nvim-treesitter.configs").setup({
        -- parsers to install (or "all")
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "html",
          "css",
          "javascript",
          "typescript",
          "json",
          "c",
          "cpp",
          "java",
          "python",
        },

        sync_install = false, -- install parsers asynchronously
        auto_install = true,  -- install missing parsers when entering buffer

        highlight = {
          enable = true,              -- false will disable the whole extension
          additional_vim_regex_highlighting = false, -- set to true if you rely on Vim regex highlighting
          disable = function(lang, bufnr)
            -- disable for very large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },

        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },

        -- autotag for html/xml-like files
        autotag = { enable = true },

        playground = {
          enable = true,
          updatetime = 25,
        },
      })

      -- Recommended: run a health check after installing
      vim.cmd([[command! TSHealthCheck lua vim.schedule(function() vim.cmd(':checkhealth nvim-treesitter') end)]])
    end,
  },
}
