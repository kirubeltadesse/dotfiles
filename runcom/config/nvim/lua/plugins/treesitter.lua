return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "json",
        "make",
        "python",
        "vim",
        "vimdoc",
        "lua",
        "javascript",
        "typescript",
        "java",
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- disable = function(lang, buf)
        --     if lang == 'markdown' then
        --         return true
        --     end
        -- end,
      },
      indent = { enable = true },
      folding = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>", -- set to `false` to disable one of the mappings
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
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
            ["ao"] = "@comment.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = true,
        },
        -- If you later want swap/move, add them here as well.
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }, -- on-demand
    keys = {
      { "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", desc = "TS Playground" },
    },
  },
}
