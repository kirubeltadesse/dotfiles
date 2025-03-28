return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 40,
            },
            renderer = {
                group_empty = true,
            },
            git = {
                ignore = false,
            },
            filters = {
                dotfiles = true,
            },

        }
        vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<cr>", { desc = "NvimTreeToggle" })
        vim.keymap.set("n", "<leader>pn", ":NvimTreeFindFile<CR>", { desc = "NvimTreeFindFile" })
        vim.keymap.set("n", "<F5>", ":NvimTreeRefresh<CR>", { desc = "NvimTreeRefresh" })
    end,
}
