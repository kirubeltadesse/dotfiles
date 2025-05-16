return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	keys = {
		-- Basic key mappings
		{
			"<leader>pf",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find Files",
		},
		{
			"<C-p>",
			function()
				require("fzf-lua").git_files()
			end,
			desc = "Git Files Search",
		},
		{
			"<leader>lg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[L]ive [G]rep",
		},
		{
			"<leader>pd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "[P]review [D]iagnostics",
		},
		{
			"<leader>pb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "[P]review [B]uffers",
		},
		{
			"<leader>pm",
			function()
				require("fzf-lua").marks()
			end,
			desc = "[P]review [M]arks",
		},
		{
			"<leader>ps",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "[P]review [S]ymbols",
		},
		{
			"<leader>vh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "Vim Help Tags",
		},

		--Git-related key mappings
		{
			"<leader>gc",
			function()
				require("fzf-lua").git_commits()
			end,
			desc = "Git [C]ommits",
		},
		{
			"<leader>gcf",
			function()
				require("fzf-lua").git_bcommits()
			end,
			desc = "Git [C]ommits for current [F]ile",
		},
		{
			"<leader>gb",
			function()
				require("fzf-lua").git_branches()
			end,
			desc = "Git [B]ranch",
		},
		{
			"<leader>gps",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "Git [S]tatus",
		},

		--Advanced example: Live grep with custom input
		{
			"<leader>gs",
			function()
				require("fzf-lua").grep({ search = vim.fn.input("Grep > ") })
			end,
			desc = "[G]rep [S]tring",
		},

		-- Search Neovim configuration files
		{
			"<leader>sn",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},

		-- Yanked search
		{
			"<leader>py",
			function()
				local word = vim.fn.getreg('"')
				require("fzf-lua").grep({ search = word })
			end,
			desc = "[P]review [Y]anked last search",
		},

		-- Visual selection search
		--
		{
			"<leader>pws",
			function()
				local word = vim.fn.expand("<cword>")
				require("fzf-lua").grep({ search = word })
			end,
			desc = "[P]review [W]ord [S]earch under cursor",
		},

		{
			"<leader>pvs",
			function()
				local word = vim.fn.getreg("v")
				require("fzf-lua").grep({ search = word })
			end,
			desc = "[P]review [V]isual [S]earch under cursor",
			mode = { "v" },
		},

		-- Notebook search
		{
			"<leader>n",
			function()
				require("swarmies.fzf_nb").nb_find_files()
			end,
			desc = "[N]otebooks Find Files",
		},
		{
			"<leader>ne",
			function()
				require("swarmies.fzf_nb").nb_open_encrypted()
			end,
			desc = "[N]otebooks [E]ncrypted",
		},
		{
			"<leader>ln",
			function()
				require("swarmies.fzf_nb").nb_live_grep()
			end,
			desc = " [L]ive [N]otebooks grap",
		},
		--
	},
}
