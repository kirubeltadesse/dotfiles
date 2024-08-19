return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
        -- TODO: make it work with trouble
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        vim.keymap.set('n', '<leader>t', vim.cmd.TodoTelescope)
    },
}
