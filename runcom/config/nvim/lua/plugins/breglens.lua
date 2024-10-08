return {
    'https://bbgithub.dev.bloomberg.com/apalazzi2/breglens.nvim',
    config = function()
        require('breglens').setup()

        vim.keymap.set("n", "<leader>bl", vim.cmd.BregLens)
    end
}
