return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            -- Replace the language servers listed here
            -- with the ones you want to install
            ensure_installed = {
                "black",
                "pyright",
                "ruff",
                "tsserver",
                "lua_ls",
                "rust_analyzer",
                "bashls",
                "debugpy",
                "isort"
            },
            auto_install = true,
        })

        -- Set up LSP with nvim-cmp capabilities
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        -- Setup handlers for each language server
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,

            -- Example of custom handlers
            ["pyright"] = function()
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    settings = { python = { analysis = { typeCheckingMode = "basic" } } },
                })
            end,

            ["ruff"] = function()
                lspconfig.ruff_lsp.setup({
                    capabilities = capabilities,
                })
            end,


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

            ["rust_analyzer"] = function()
                lspconfig.rust_analyzer.setup({
                    capabilities = capabilities,
                })
            end,

            ["tsserver"] = function()
                lspconfig.tsserver.setup({
                    capabilities = capabilities,
                })
            end,

            ["bashls"] = function()
                lspconfig.bashls.setup({
                    capabilities = capabilities,
                })
            end,
        })
    end,
}
