-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("KirubelLspConfig", {}),
  callback = function(ev)
    local map = function(key, func, desc)
      vim.keymap.set("n", key, func, { desc = "LSP: " .. desc, buffer = ev.buf })
    end
    map("K", vim.lsp.buf.hover, "Go method definition")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>vws", vim.lsp.buf.workspace_symbol, "Search Symobls Matching")
    map("<leader>vd", vim.diagnostic.open_float, "Diagnostic open float")
    map("<leader>r", vim.lsp.buf.rename, "Buffer rename")
    map("<C-k>", vim.lsp.buf.signature_help, "Help signature")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yenking (Copying) text",
  group = vim.api.nvim_create_augroup("kirubelHighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require("swarmies")
