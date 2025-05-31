return {
	url = "https://bbgithub.dev.bloomberg.com/apalazzi2/breglens.nvim",
	opts = {},
	keys = {
		{
			"<leader>bl",
			function()
				vim.cmd.BregLens()
			end,
			desc = "Breg detail info",
		},
	},
}
