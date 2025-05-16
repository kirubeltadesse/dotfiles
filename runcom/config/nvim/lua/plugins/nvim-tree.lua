return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
	},
	opts = {
		update_focused_file = {
			enable = true,
			update_cwd = true,
			ignore_list = { ".git", "node_modules", ".cache" },
		},
		disable_netrw = true,
		hijack_netrw = true,
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			adaptive_size = true,
			width = 30,
			side = "left",
			signcolumn = "yes",
		},
		renderer = {
			group_empty = true,
		},
		git = {
			ignore = false,
		},
		filters = {
			dotfiles = true,
		},
	},

	keys = {
		{ "<leader>pv", ":NvimTreeToggle<cr>", desc = "NvimTreeToggle" },
		{ "<leader>pn", ":NvimTreeFindFile<CR>", desc = "NvimTreeFindFile" },
		{ "<F5>", ":NvimTreeRefresh<CR>", desc = "NvimTreeRefresh" },
	},
}
