local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

--- local jdtls_setup = require("plugin.jdtls.lua").jdtls_setup

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('KirubelLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        print("LSP attached for buffer: " .. ev.buf)
        --FIXME: might need to make function call
        --vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration", buffer = ev.buf })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition", buffer = ev.buf })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Go method definition", buffer = ev.buf })
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol,
            { desc = "Search Symobls Matching", buffer = ev.buf })
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Diagnostic open float", buffer = ev.buf })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references", buffer = ev.buf })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Buffer rename", buffer = ev.buf })
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Help signature", buffer = ev.buf })

        -- if ev.data and ev.data.name == "sonarlint" then
        --     vim.keymap.set("n", "<leader>li",
        --         ":lua vim.lsp.buf.execute_command({ command = 'sonarlint.showIssues' })<CR>", opts)
        --     vim.keymap.set("n", "<leader>lr", ":lua vim.lsp.buf.execute_command({ command = 'sonarlint.showRules' })<CR>",
        --         opts)
        -- end


        -- jdtls-specific keybindings
        if vim.bo[ev.buf].filetype == "java" then
            vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
            vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
            vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
            vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
            vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
            vim.keymap.set('x', 'crm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
        end
    end
})

require("lazy").setup("plugins")

-- local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })

-- Force LSP to start
vim.api.nvim_create_autocmd('BufReadPost', {
    group = java_cmds,
    pattern = '*.java',
    desc = 'Force start jdtls',
    callback = function()
        vim.cmd('set filetype=java')
        jdtls_setup()
    end,
})
require("swarmies")
