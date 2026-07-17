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
          local buf_dir = vim.fn.expand("%:p:h")
          local pom = vim.fs.find("pom.xml", { upward = true, path = buf_dir })[1]
          local gradle = vim.fs.find({ "build.gradle", "build.gradle.kts" }, { upward = true, path = buf_dir })[1]

          local cmd, dir
          if pom then
            cmd = { "mvn", "spotless:apply" }
            dir = vim.fn.fnamemodify(pom, ":h")
          elseif gradle then
            cmd = { vim.fn.fnamemodify(gradle, ":h") .. "/gradlew", "spotlessApply" }
            dir = vim.fn.fnamemodify(gradle, ":h")
          else
            vim.notify("No pom.xml or build.gradle found", vim.log.levels.WARN)
            return
          end

          vim.notify("Running " .. table.concat(cmd, " ") .. "…", vim.log.levels.INFO)
          vim.fn.jobstart(cmd, {
            cwd = dir,
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.cmd("checktime")
                  vim.notify("Spotless applied", vim.log.levels.INFO)
                else
                  vim.notify("Spotless failed (exit " .. code .. ")", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "Format with Spotless",
        ft = "java",
      },
    },
  },
}
