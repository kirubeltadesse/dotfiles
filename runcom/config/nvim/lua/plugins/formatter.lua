return {
  { "nmac427/guess-indent.nvim", opts = {} },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        cpp = { "clang_format" },
        java = { "spotless_apply" },
      },
      formatters = {
        spotless_apply = {
          command = "mvn",
          args = { "spotless:apply" },
          cwd = require("conform.util").root_file({ "pom.xml" }),
          stdin = false,
        },
      },
    },
  },
}
