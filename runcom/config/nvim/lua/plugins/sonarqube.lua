return {
  "iamkarasik/sonarqube.nvim",
  config = function()
    require("sonarqube").setup({
      rules = {
        enabled = true,
        ["typescript:S103"] = { parameters = { maximumLineLength = 100 } },
      },
      javascript = { enabled = true, clientNodePath = vim.fn.exepath("node") },
      python = { enabled = true },
    })
  end,
}
