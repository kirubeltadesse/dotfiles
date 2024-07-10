vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- 
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)
-- 
--

-- will not loss the past
vim.keymap.set("x", "<leader>p", "\"_dP")


vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")


-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("v", "<leader>d", function()
    vim.lsp.buf.format()
end)

-- quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>d", "<cmd>lprev<CR>zz")


vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- pandoc
-- Enable folding for markdown and pandoc files
vim.g.vimwiki_filetypes = {'markdown'}
vim.g.vimwiki_folding = 'custom'
vim.g['pandoc#folding#mode'] = 'stacked'
vim.g['pandoc#modules#enabled'] = {'folding', 'command'}

vim.g.pandoc_folding = 1
-- vim.g.vim_markdown_folding_disabled = 1  -- Disable vim-markdown folding as it conflicts with pandoc folding

-- Set up custom folding for markdown
vim.cmd [[
  autocmd FileType markdown setlocal foldmethod=expr
  autocmd FileType markdown setlocal foldexpr=pandoc#fold#level(v:lnum)
  autocmd FileType markdown setlocal foldtext=MyFoldText()
]]

-- Custom fold text function
function MyFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local fold_size = vim.v.foldend - vim.v.foldstart + 1
    return line .. ' ... ' .. fold_size .. ' lines'
end

-- Function to open all folds and preserve cursor position
function OpenAllFoldsPreserveCursor()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd('normal! zR')
    vim.fn.setpos('.', save_cursor)
end

-- Keybindings for folding
-- FIXME: this line need to be fix
-- vim.api.nvim_set_keymap('n', 'zR', ':lua OpenAllFoldsPreserveCursor()<CR>', { noremap = true, silent = true }) -- Open all folds
vim.api.nvim_set_keymap('n', 'zM', ':setlocal foldlevel=0<CR>', { noremap = true, silent = true })  -- Close all folds

