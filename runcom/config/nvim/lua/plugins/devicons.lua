return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = {},
      },
    },
    opts = {},
  },
  {
    "mskelton/termicons.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    build = false,
    opts = {},
  },
}
