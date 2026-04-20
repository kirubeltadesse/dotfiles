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
        java = { "google-java-format" },
      },
    },
    keys = {
      {
        "<leader>cS",
        function()
          local pom = vim.fs.find("pom.xml", { upward = true, path = vim.fn.expand("%:p:h") })[1]
          if not pom then
            vim.notify("No pom.xml found — not a Maven project", vim.log.levels.WARN)
            return
          end
          local dir = vim.fn.fnamemodify(pom, ":h")
          vim.notify("Running mvn spotless:apply…", vim.log.levels.INFO)
          vim.fn.jobstart({ "mvn", "spotless:apply" }, {
            cwd = dir,
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.cmd("checktime") -- reload changed buffers
                  vim.notify("Spotless applied", vim.log.levels.INFO)
                else
                  vim.notify("Spotless failed (exit " .. code .. ")", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "Format with Spotless (Maven)",
        ft = "java",
      },
    },
  },
}
