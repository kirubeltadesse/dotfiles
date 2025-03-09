return {
    "preservim/vimux",
    event= 'VeryLazy',
    config = function()
        vim.keymap.set('n', '<leader>vp', vim.cmd.VimuxPromptCommand, { desc = "[V]im [P]rompt", noremap = true })
        vim.keymap.set('n', '<leader>vl', vim.cmd.VimuxRunLastCommand, { desc = "[V]im [L]ast", noremap = true })
        vim.keymap.set('n', '<leader>vi', vim.cmd.VimuxInspectRunner, { desc = "[V]im [I]nspect", noremap = true })
        vim.keymap.set('n', '<leader>vz', vim.cmd.VimuxZoomRunner, { desc = "[V]im [Z]oom", noremap = true })
    end
}
