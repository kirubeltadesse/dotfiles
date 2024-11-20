return {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Fugitive" });
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "get ours" });
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "get theirs" })
    end
}
