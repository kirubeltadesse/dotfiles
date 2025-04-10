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
require("lazy").setup("plugins")


local jdtls_ok,  jdtls = pcall(require, "jdtls")

if not jdtls_ok then
    vim.notify("Error: nvim-jdtls is not installed", vim.log.levels.ERROR)
    return
end


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('KirubelLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
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

    end
})

require("swarmies")
