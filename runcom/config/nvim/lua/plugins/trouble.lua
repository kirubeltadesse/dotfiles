return {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup{
            icons = false,
            use_lsp_diagnostic_signs = true,
            auto_preview = false,
            auto_fold = true,
            use_telescope = true,
            action_keys = {
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = {"<cr>", "<tab>"},
                toggle_mode = "m",
                toggle_preview = "<leader>pv",
                preview = "p",
                close_folds = {"zM", "zm"},
                open_folds = {"zR", "zr"},
                toggle_fold = "zA",
                previous = "k",
                next = "j",
            },
            indent_lines = true,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
            },
            mode = "lsp_document_diagnostics",
            fold_open = "",
            fold_closed = "",
            lsp_colors = {
                error = "#db4b4b",
                warning = "#e0af68",
                information = "#0db9d7",
                hint = "#10B981",
            },
        }
        vim.keymap.set("n", "<leader>tt", function()
            require("trouble").toggle()
        end)

        vim.keymap.set("n", "[d", function()
            require("trouble").next({skip_groups = true, jump = true});
        end)

        vim.keymap.set("n", "]d", function()
            require("trouble").previous({skip_groups = true, jump = true});
        end)

    end
}
