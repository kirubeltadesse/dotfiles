return {
	{
		"github/copilot.vim",
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		version = "v1.2.0",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"moyiz/blink-emoji.nvim",
			-- "giuxtaposition/blink-cmp-copilot", FIXME: copilot not working on the current version
			"L3MON4D3/LuaSnip",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			snippets = { preset = "luasnip" },
			completion = { documentation = { auto_show = true } },
			signature = { enabled = true },

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" }, -- "copilot" },
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},

					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					-- copilot = {
					-- 	name = "copilot",
					-- 	module = "blink-cmp-copilot",
					-- 	score_offset = 100,
					-- 	async = true,
					-- },
				},
			},
		},
	},
}
