return {
  -- TOOLING: COMPLETION, DIAGNOSTICS, FORMATTING
  -- Manager for external tools (LSPs, linters, debuggers, formatters)
  -- auto-install of those external tools
  "ellisonleao/dotenv.nvim",
  init = function()
    require("dotenv").setup({
      enable_on_load = true, -- will load your .env file upon loading a buffer
      verbose = false,
    })
  end,
}
