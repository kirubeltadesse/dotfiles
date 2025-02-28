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
            vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Git [C]ommits" })
            vim.keymap.set('n', '<leader>gcf', builtin.git_bcommits, { desc = "Git [C]ommits for current [F]ile" })
            vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Git [B]ranch" })
            vim.keymap.set('n', '<leader>gps', builtin.git_status, { desc = "Git [S]tatus" })
            vim.keymap.set('n', '<leader>pd', builtin.diagnostics, { desc = "Search [D]iagnostics" })
            vim.keymap.set('n', '<leader>pm', builtin.marks, { desc = "[P]review [M]arks" })
            vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "[P]review [B]uffers" })
            vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "[L]ive [G]rep" })
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
                defaults = {
                    mappings = {
                        i = { -- Insert mode
                            ["<M-j>"] = require("telescope.actions").preview_scrolling_down, -- Alt + j
                            ["<M-k>"] = require("telescope.actions").preview_scrolling_up,  -- Alt + k
                        },
                        n = { -- Normal mode
                            ["<M-j>"] = require("telescope.actions").preview_scrolling_down, -- Alt + j
                            ["<M-k>"] = require("telescope.actions").preview_scrolling_up,  -- Alt + k
                        }
                    },
                    file_ignore_patterns = {".git/","node_modules/", "build/", "dist/" },
                },
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
