return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                -- Navigation
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { buffer = bufnr })

                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { buffer = bufnr })

                -- Git actions with which-key registration
                vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git Stage Hunk" })
                vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git Reset Hunk" })
                vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git Stage Buffer" })
                vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })
                vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git Reset Buffer" })
                vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git Preview Hunk" })
                vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line { full = true } end,
                    { desc = "Git Blame Line" })
                vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Git Diff" })
                vim.keymap.set("n", "<leader>hD", function() gitsigns.diffthis('~') end, { desc = "Git Diff with '~'" })
                vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Blame" })
                vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
                -- Visual mode mappings for hunk actions
                vim.keymap.set("v", "<leader>hs",
                    function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Stage Hunk (Visual)" })
                vim.keymap.set("v", "<leader>hr",
                    function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Reset Hunk (Visual)" })

                -- Text object for selecting hunks
                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
                    { desc = "Select Git Hunk", buffer = bufnr })
            end
        }
    end
}
