return { 
    'nvim-treesitter/nvim-treesitter', 
    build = ':TSUpdate',
    event= 'VeryLazy',
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {"lua", "javascript"},
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
