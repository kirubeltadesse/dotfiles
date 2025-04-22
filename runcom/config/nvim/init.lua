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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('KirubelLspConfig', {}),
    callback = function(ev)
        local map = function(key, func, desc)
            vim.keymap.set("n", key, func, { desc = "LSP: " .. desc, buffer = ev.buf })
        end

        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("K", vim.lsp.buf.hover, "Go method definition")
        map("<leader>vws", vim.lsp.buf.workspace_symbol,
            "Search Symobls Matching")
        map("<leader>vd", vim.diagnostic.open_float, "Diagnostic open float")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>gr", require("telescope.builtin").lsp_references, "Go to references")
        map("<leader>r", vim.lsp.buf.rename, "Buffer rename")
        map("<C-h>", vim.lsp.buf.signature_help, "Help signature")
    end
})


vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yenking (Copying) text",
    group = vim.api.nvim_create_augroup("kirubelHighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

require("swarmies")
