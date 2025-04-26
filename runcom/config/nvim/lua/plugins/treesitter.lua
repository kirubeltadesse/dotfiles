return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "json",
                "make",
                "python",
                "vim",
                "vimdoc",
                "lua",
                "javascript",
                "typescript",
                "java",
            },
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == 'markdown' then
                        return true
                    end
                end,
            },
            indent = { enable = true },
            folding = {
                enable = true,
            }
        })
    end,
}
