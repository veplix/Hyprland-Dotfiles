return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },

    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "bash",
        "fish",
        "toml",
        "yaml",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "vue",
        "svelte",
        "c",
        "cpp",
        "rust",
        "go",
        "python",
        "ruby",
        "markdown",
        "markdown_inline",
        "regex",
        "gitignore",
        "dockerfile",
        "c_sharp",
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        disable = { "python", "yaml" },
      },

      autotag = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
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
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      vim.defer_fn(function()
        vim.cmd("TSEnable highlight")
      end, 20)

      if vim.lsp.semantic_tokens then
        vim.lsp.semantic_tokens.enabled = false
      end
    end,
  },
}
