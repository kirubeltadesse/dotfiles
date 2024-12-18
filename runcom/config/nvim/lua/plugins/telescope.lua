return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.6',
        -- or                            , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = " Find Files" })
            vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git Files Search" })
            vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "Live Grep" })
            vim.keymap.set('n', '<leader>pws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word });
            end, { desc = "Grep Current Word" })
            vim.keymap.set('n', '<leader>pWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word });
            end, { desc = "Grep Current WORD" })
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grap > ") });
            end, { desc = "Grep Input" })
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Vim Help Tags" })
        end

    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        -- This is your opts table
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    }
}
