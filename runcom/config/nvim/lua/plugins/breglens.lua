return {
  name = "BregLens",
  url = "https://bbgithub.dev.bloomberg.com/apalazzi2/breglens.nvim",
  opts = {},
  keys = {
    {
      "<C-b>",
      function()
        vim.cmd("BregLens")
      end,
      desc = "Breg detail info",
      mode = "n",
    },
  },
}
