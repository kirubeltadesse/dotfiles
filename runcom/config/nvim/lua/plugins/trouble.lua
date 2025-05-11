return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	dependencies = {
		"echasnovski/mini.icons",
		"folke/todo-comments.nvim",
	},
	config = function()
		require("trouble").setup({
			--use_lsp_diagnostic_signs = true,
			auto_preview = false,
			auto_fold = true,
			use_telescope = true,
			action_keys = {
				close = "q",
				cancel = "<esc>",
				refresh = "r",
				jump = { "<cr>", "<tab>" },
				toggle_mode = "m",
				toggle_preview = "<leader>tt",
				preview = "p",
				close_folds = { "zM", "zm" },
				open_folds = { "zR", "zr" },
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
			--         mode = "lsp_document_diagnostics",
			modes = {
				test = {
					mode = "diagnostics",
					preview = {
						type = "split",
						relative = "win",
						position = "right",
						size = 0.3,
					},
				},
			},
			fold_open = "",
			fold_closed = "",
			lsp_colors = {
				error = "#db4b4b",
				warning = "#e0af68",
				information = "#0db9d7",
				hint = "#10B981",
			},
		})

		vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>")
		vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
		vim.keymap.set("n", "<leader>[d", "<cmd>Trouble diagnostics next<cr>")
		vim.keymap.set("n", "<leader>]d", "<cmd>Trouble diagnostics prev<cr>")
		vim.keymap.set("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")
	end,
}
