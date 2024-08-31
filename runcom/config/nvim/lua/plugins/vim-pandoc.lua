return {
    {
        'vim-pandoc/vim-pandoc',
        config = function()
            -- pandoc
            -- Enable folding for markdown and pandoc files
            vim.g.vimwiki_filetypes = { 'markdown' }
            vim.g.vimwiki_folding = 'custom'
            vim.g['pandoc#folding#mode'] = 'stacked'
            vim.g['pandoc#modules#enabled'] = { 'folding', 'command' }

            vim.g.pandoc_folding = 1
            vim.g.vim_markdown_override_foldtext = 0 -- Disable vim-markdown folding as it conflicts with pandoc folding
            vim.g.vim_markdown_folding_disabled = 1  -- Disable vim-markdown folding as it conflicts with pandoc folding

            -- Ensure pandoc syntax settings for link hiding
            vim.g['pandoc#syntax#conceal#use'] = 1
            vim.g['pandoc#syntax#conceal#urls'] = 1
            vim.g['pandoc#syntax#conceal#links'] = 1
            vim.g['pandoc#syntax#conceal#footnotes'] = 1

            -- Set up custom folding for markdown
            vim.cmd [[
            augroup pandoc_folding
                autocmd!
                autocmd FileType markdown setlocal foldmethod=expr
                autocmd FileType markdown setlocal foldexpr=pandoc#fold#level(v:lnum)
                autocmd FileType markdown setlocal foldtext=MyFoldText()
                autocmd FileType markdown setlocal foldlevelstart=99
            augroup END
        ]]

            -- Custom fold text function
            function MyFoldText()
                local line = vim.fn.getline(vim.v.foldstart)
                local fold_size = vim.v.foldend - vim.v.foldstart + 1
                return line .. ' ... ' .. fold_size .. ' lines'
            end

            -- Function to open all folds and preserve cursor position
            --function OpenAllFoldsPreserveCursor()
            --    local save_cursor = vim.fn.getpos(".")
            --    vim.cmd('normal! zR')
            --    vim.fn.setpos('.', save_cursor)
            --end
            --
            ---- Function to close all folds and preserve cursor position
            --function CloseAllFoldsPreserveCursor()
            --    local save_cursor = vim.fn.getpos(".")
            --    vim.cmd('normal! zM')
            --    vim.fn.setpos('.', save_cursor)
            --end


            -- Keybindings for folding
            -- vim.api.nvim_set_keymap('n', 'zR', ':lua OpenAllFoldsPreserveCursor()<CR>', { noremap = true, silent = true }) -- Open all folds
            -- vim.api.nvim_set_keymap('n', 'zM', ':lua CloseAllFoldsPreserveCursor()<CR>', { noremap = true, silent = true })  -- Close all folds
        end
    },
    {
        'vim-pandoc/vim-pandoc-syntax'
    },
    {
        'plasticboy/vim-markdown',
    },
    {
        'folke/zen-mode.nvim',
        event = "BufRead"
    }


}
