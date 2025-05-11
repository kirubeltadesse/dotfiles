return {
  { "nmac427/guess-indent.nvim", opts = {} },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				cpp = { "clang_format" },
			},

			format_on_save = {
				timeout_ms = 500,
				async = false,
				lsp_format = "fallback",
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end,
				desc = "LSP Format Buffer",
				mode = { "n", "v" },
			},
		},
	},
}
