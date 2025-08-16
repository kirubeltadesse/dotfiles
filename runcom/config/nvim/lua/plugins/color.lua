return {
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
      require("rose-pine").setup({
        disable_background = true,
        overrides = function(colors)
          return {
            ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
            ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
            ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
            ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
            ["@markup.list.markdown"] = { link = "Function" }, -- + list
            ["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
            ["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [X] checked list item
          }
        end,
      })
    end,
  },
}
