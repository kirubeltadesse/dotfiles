return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	keys = {
		-- { "<leader>pv", ":Oil --float <cr>", desc = "Oil" },
		{ "-", ":Oil --float <CR>", desc = "Oil", mode = { "n" } },
		-- { "<leader>pn", ":Oil --float %:h<CR>", desc = "OilFindFile" },
		-- { "<F5>", ":OilRefresh<CR>", desc = "OilRefresh" },
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
