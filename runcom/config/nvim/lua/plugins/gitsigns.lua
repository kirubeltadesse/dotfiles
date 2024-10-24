return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gs = require('gitsigns')

                -- Navigation
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gs.nav_hunk('next')
                    end
                end, { buffer = bufnr })

                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gs.nav_hunk('prev')
                    end
                end, { buffer = bufnr })

                -- Git actions with which-key registration
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Git Stage Hunk" })
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Git Reset Hunk" })
                vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { desc = "Git Stage Buffer" })
                vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk,
                    { desc = "Git Undo Stage Hunk" })
                vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Git Reset Buffer" })
                vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Git Preview Hunk" })
                vim.keymap.set("n", "<leader>hb", function() gs.blame_line { full = true } end,
                    { desc = "Git Blame Line" })
                vim.keymap.set("n", "<leader>hd", gs.diffthis, { desc = "Git Diff" })
                vim.keymap.set("n", "<leader>hD", function() gs.diffthis('~') end,
                    { desc = "Git Diff with '~'" })
                vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame,
                    { desc = "Toggle Blame" })
                vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })
                -- Visual mode mappings for hunk actions
                vim.keymap.set("v", "<leader>hs",
                    function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Stage Hunk (Visual)" })
                vim.keymap.set("v", "<leader>hr",
                    function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "Reset Hunk (Visual)" })

                -- Text object for selecting hunks
                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
                    { desc = "Select Git Hunk" })
            end
        }
    end
}
