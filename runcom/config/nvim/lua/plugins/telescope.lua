return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.6',
        -- or                            , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            local nb_telescope = require('swarmies.telescope_nb')

            local function is_git_repo()
                return vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] == "true"
            end

            vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find Files" })
            vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git Files Search" })
            vim.keymap.set('n', '<leader>gc', function()
                if is_git_repo() then
                    builtin.git_commits()
                else
                    print("Git is not initialized in this directory")
                end
            end, { desc = "Git [C]ommits" })
            vim.keymap.set('n', '<leader>gcf', function()
                if is_git_repo() then
                    builtin.git_bcommits()
                else
                    print("Git is not initialized in this directory")
                end
            end, { desc = "Git [C]ommits for current [F]ile" })
            vim.keymap.set('n', '<leader>gca',
                function()
                    local author = vim.fn.input("Author: ")
                    if author ~= "" then
                        if is_git_repo() then
                            builtin.git_commits({
                                git_command = {"git", "log", "--oneline", "--author=" .. author},
                                prompt_title = "Git Commits by " .. author,
                            })
                        else
                            print("Git is not initialized in this directory")
                        end
                    end
                end, { desc = "Git [C]ommits by [A]uthor" })
            vim.keymap.set('n', '<leader>gb', function()
                if is_git_repo() then
                    builtin.git_branches()
                else
                    print("Git is not initialized in this directory")
                end
            end, { desc = "Git [B]ranch" })
            vim.keymap.set('n', '<leader>gps', function()
                if is_git_repo() then
                    builtin.git_status()
                else
                    print("Git is not initialized in this directory")
                end
            end, { desc = "Git [S]tatus" })
            vim.keymap.set('n', '<leader>gs', function()
                builtin.grep_string({ search = vim.fn.input("Grap > ") });
            end, { desc = "[G]rep [S]tring" })
            vim.keymap.set('n', '<leader>nb', nb_telescope.nb_find_files, { desc = "[N]ote[B]ooks Find Files" })
            vim.keymap.set('n', '<leader>ne', nb_telescope.nb_open_encrypted, { desc = "[N]ote[B]ooks [E]ncrypted" })
            vim.keymap.set('n', '<leader>nbl', nb_telescope.nb_live_grep, { desc = "[N]ote[B]ooks [L]ive grap" })
            vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "[L]ive [G]rep" })
            vim.keymap.set('n', '<leader>pd', builtin.diagnostics, { desc = "Search [D]iagnostics" })
            vim.keymap.set('n', '<leader>pm', builtin.marks, { desc = "[P]review [M]arks" })
            vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "[P]review [B]uffers" })
            vim.keymap.set('n', '<leader>ps', builtin.lsp_document_symbols, { desc = "[P]review [S]ymbols" })
            vim.keymap.set('n', '<leader>pws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word });
            end, { desc = "[p]riview [w]ord [s]earch under cursor" })
            vim.keymap.set('n', '<leader>pWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word });
            end, { desc = "[p]riview [W]ord [s]earch under cursor" })
            vim.keymap.set('v', '<leader>pvs', function()
                local word = vim.fn.getreg("v")
                builtin.grep_string({ search = word });
            end, { desc = "[P]riview [V]isual [S]earch under cursor" })
            vim.keymap.set('n', '<leader>py', function()
                local word = vim.fn.getreg('"')
                builtin.grep_string({ search = word });
            end, { desc = "[P]riview [Y]anked last search " })
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Vim Help Tags" })
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        -- This is your opts table
        config = function()
            local actions = require('telescope.actions')
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = { -- Insert mode
                            ["<M-j>"] = actions.preview_scrolling_down, -- Alt + j
                            ["<M-k>"] = actions.preview_scrolling_up,  -- Alt + k
                            ["CR>"] = function(prompt_bufnr)
                                -- handle opening multiple selected files
                                local picker = actions.get_current_picker(prompt_bufnr)
                                local selections = picker:get_multi_selection()
                                if #selections > 0 then
                                    for _, entry in ipairs(selections) do
                                        vim.cmd("tabedit " .. entry.value)
                                    end
                                else
                                    actions.select_default(prompt_bufnr)
                                end
                            end,

                        },
                        n = { -- Normal mode
                            ["<M-j>"] = actions.preview_scrolling_down, -- Alt + j
                            ["<M-k>"] = actions.preview_scrolling_up,  -- Alt + k
                        }
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        -- "--no-ignore", --Ignore .gitignore
                    },
                    file_ignore_patterns = {".git/","node_modules/", "build/", "*/target/*", "dist/", "report-aggregate/*", "code-statistics/*" },
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
