return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			only_in_normal_buffers = true,
			-- Ensure highlight never reappears by removing it on CursorMoved
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = "*",
				callback = function()
					require("mini.trailspace").unhighlight()
				end,
			}),
		},
		keys = {
			{
				"<leader>cw",
				function()
					require("mini.trailspace").trim()
				end,
				desc = "Erase Whitespace",
			},
		},
	},
}
