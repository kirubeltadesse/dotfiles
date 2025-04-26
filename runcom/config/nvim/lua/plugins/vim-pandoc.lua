return {
    {
        'vim-pandoc/vim-pandoc',
        config = function()
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
                autocmd FileType markdown setlocal foldtext=MyMarkdownFoldText()
                autocmd FileType markdown silent! normal! zM
            augroup END
        ]]

            -- Custom fold text function
            function MyMarkdownFoldText()
                local line = vim.fn.getline(vim.v.foldstart)
                local fold_size = vim.v.foldend - vim.v.foldstart + 1
                return line .. ' ... ' .. fold_size .. ' lines'
            end

            -- Keybinding to open link under cursor
            vim.keymap.set("n", "<leader>ol", function()
                -- Get the current line
                local line = vim.fn.getline(".")

                -- Match the Markdown link pattern and extract the URL
                local url = line:match("%[.-%]%((.-)%)")

                if url then
                    url = url:gsub("^%s+", ""):gsub("%s+$", "") -- Trim spaces
                    if url:match("^https?://") then
                        vim.fn.jobstart({ "open", url }, { detach = true })
                    else
                        print("No valid URL under cursor: " .. url)
                    end
                else
                    print("No valid URL found under cursor")
                end
            end, { noremap = true, silent = true })
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
