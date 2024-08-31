return {
    "preservim/vimux",
    event= 'VeryLazy',
    config = function()
        vim.keymap.set('n', '<leader>vp', vim.cmd.VimuxPromptCommand)
        vim.keymap.set('n', '<leader>vl', vim.cmd.VimuxRunLastCommand)
        vim.keymap.set('n', '<leader>vi', vim.cmd.VimuxInspectRunner)
        vim.keymap.set('n', '<leader>vz', vim.cmd.VimuxZoomRunner)
    end
}
