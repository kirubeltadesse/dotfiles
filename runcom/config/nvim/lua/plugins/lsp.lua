return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		-- Set up Mason-Tool-Installer
		require("mason-tool-installer").setup({
			ensure_installed = {
				"clangd",
				"pyright",
				"stylua", -- Lua formatter
				"prettierd", -- JavaScript/TypeScript formatter
				"black", -- Python formatter
				"isort", -- Python import sorter
			},
		})

		-- Set up Mason-LSPConfig
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "rust_analyzer", "bashls" }, -- Add your desired LSP servers here
			automatic_installation = false,
		})

		-- Set up LSP capabilities with blink.cmp
		local lspconfig = require("lspconfig")
		local original_capabilities = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

		-- Set up LSP servers with custom handlers
		require("mason-lspconfig").setup_handlers({
			-- Default handler for all servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- Custom handler for clangd
			["clangd"] = function()
				lspconfig.clangd.setup({
					cmd = { "clangd" },
					capabilities = capabilities,
				})
			end,

			-- Custom handler for pyright
			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
							},
						},
					},
				})
			end,

			-- Custom handler for lua_ls
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
								path = vim.split(package.path, ";"),
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								},
							},
						},
					},
				})
			end,

			-- Custom handler for rust_analyzer
			["rust_analyzer"] = function()
				lspconfig.rust_analyzer.setup({
					capabilities = capabilities,
				})
			end,

			-- Custom handler for bashls
			["bashls"] = function()
				lspconfig.bashls.setup({
					capabilities = capabilities,
				})
			end,

			-- Custom handler for jdtls
			["jdtls"] = function()
				-- jdtls is configured separately in java.lua
			end,
		})
	end,
}
