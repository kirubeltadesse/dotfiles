return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            -- add mappings for debugging
            vim.keymap.set('n', "<F5>", "<cmd>lua require('dap').continue()<CR>")
            vim.keymap.set('n', "<F10>", "<cmd>lua require('dap').step_over()<CR>")
            vim.keymap.set('n', "<F11>", "<cmd>lua require('dap').step_into()<CR>")
            vim.keymap.set('n', "<F12>", "<cmd>lua require('dap').step_out()<CR>")
            vim.keymap.set('n', "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
            vim.keymap.set('n', "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
            vim.keymap.set('n', "<leader>lp", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
            vim.keymap.set('n', "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>")
            vim.keymap.set('n', "<leader>dl", "<cmd>lua require('dap').run_last()<CR>")
            vim.keymap.set('n', "<leader>di", "<cmd>lua require('dap.ui.variables').hover()<CR>")

            require("dap").adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }
            require("dap").configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        return vim.fn.exepath("python")
                    end,
                },
            }
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            -- setup python debugger
            -- replace the path with the path to your python executable
            -- where debugpy is ensure_installed
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/bin/python ")
        end,
    },
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			-- Replace the language servers listed here
			-- with the ones you want to install
			ensure_installed = { "black", "pyright", "mypy", "debugpy", "ruff", "html", "tsserver", "lua_ls", "rust_analyzer" },
			auto_install = true,
		})

		-- Set up LSP with nvim-cmp capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require("lspconfig")
		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
			vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
		end

		-- Setup handlers for each language server
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,

			-- Example of custom handlers
			["pyright"] = function()
				lspconfig.pyright.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = { python = { analysis = { typeCheckingMode = "basic" } } },
				})
			end,
		})
	end,
}
