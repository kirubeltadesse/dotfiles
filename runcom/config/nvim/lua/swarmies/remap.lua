vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<cr>", { desc = "NvimTreeToggle" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down" })


vim.keymap.set("n", "J", "mzJ`z", { desc = "Break nextline to this line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Centered cursor for ctrl-d" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Centered cursor for ctrl-u" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Centered search next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Centered search prev" })

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
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without loss" })

-- yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to clipboard" })

vim.keymap.set("n", "<leader>x", "\"_d", { desc = "Delete" })
vim.keymap.set("v", "<leader>x", "\"_d", { desc = "Delete" })

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- formatting XML file
vim.keymap.set("v", "<leader>fx", "!xmllint --format -", { desc = "Format XML files" })

-- formatting JSON file
vim.keymap.set("v", "<leader>fj", "!jq .", { desc = "Format JSON file" })


-- Disable vim-tmux-navigation mapping in Neovim if inside a quick fix list
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "qf", -- Quick buffer type
    callback = function()
        vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "next centered cursor " })
        vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "prev centered cursor " })
    end,
})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Up centered cursor " })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Down centered cursor " })

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>",
    { desc = "Substitute the current word" })
vim.keymap.set("n", "<leader>e", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make this file Excutable" })

-- Split windows
vim.keymap.set("n", "sv", ":vsplit<Return>", { noremap = true, silent = true, desc = "Vectrical split" })
vim.keymap.set("n", "ss", ":split<Return>", { noremap = true, silent = true, desc = "Horizontal split " })

-- Tabs
vim.keymap.set("n", "te", ":tabedit", { noremap = true, silent = true, desc = "Tab edit" })
vim.keymap.set("n", "<tab>", ":tabnext<Return>", { noremap = true, silent = true, desc = "Next Tab" })
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", { noremap = true, silent = true, desc = "Previous Tab" })

-- Re-size Panes
vim.keymap.set("n", "<M-h>", '<Cmd>lua require("tmux").resize_left()<CR>', { silent = true })
vim.keymap.set("n", "<M-j>", '<Cmd>lua require("tmux").resize_bottom()<CR>', { silent = true })
vim.keymap.set("n", "<M-k>", '<Cmd>lua require("tmux").resize_top()<CR>', { silent = true })
vim.keymap.set("n", "<M-l>", '<Cmd>lua require("tmux").resize_right()<CR>', { silent = true })
