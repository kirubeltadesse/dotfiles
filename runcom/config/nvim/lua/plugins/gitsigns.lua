return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, desc, opts)
          opts = opts or {}
          opts.buffer = bufnr
          opts.desc = desc.desc
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, { desc = "next change" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, { desc = "prev change" })

        -- Git actions with which-key registration
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Git Stage Hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Git Reset Hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Git Stage Buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Git Reset Buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Git Preview Hunk" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Git Blame Line" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Git Diff" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "Git Diff with '~'" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })
        -- Visual mode mappings for hunk actions
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage Hunk (Visual)" })
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset Hunk (Visual)" })

        -- Text object for selecting hunks
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Git Hunk" })
      end,
    })
  end,
}
