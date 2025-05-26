return {
	{
		"pwntester/octo.nvim",
		opts = function(_, opts)
			vim.treesitter.language.register("markdown", "octo")
			opts.picker = "telescope"
			vim.api.nvim_create_autocmd("ExitPre", {
				group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
				callback = function(ev)
					local keep = { "octo" }
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.tbl_contains(keep, vim.bo[buf].filetype) then
							vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
						end
					end
				end,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<C-g>", vim.cmd.Git, { desc = "Git Fugitive" })
			vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "get ours" })
			vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "get theirs" })
		end,
	},
}
