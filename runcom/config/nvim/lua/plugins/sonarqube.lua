return {
  "iamkarasik/sonarqube.nvim",
  config = function()
    require("sonarqube").setup({
      rules = {
        enabled = true,
        ["typescript:S103"] = { parameters = { maximumLineLength = 100 } },
      },
      java = { enabled = true, await_jdtls = true },
      lsp = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          vim.fn.expand("~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjava.jar"),
        },
      },
      javascript = { enabled = true, clientNodePath = vim.fn.exepath("node") },
      python = { enabled = true },
    })
  end,
}
