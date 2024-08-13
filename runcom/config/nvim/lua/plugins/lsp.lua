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
                "mypy",
                --"debugpy",
                "ruff",
                "tsserver",
                "lua_ls",
                "rust_analyzer",
                "bashls",
            },
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

            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    on_attach = on_attach,
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
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,

            ["tsserver"] = function()
                lspconfig.tsserver.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,

            -- getting unknown lspconfig service name: bash-language-server error can you fix that
            ["bashls"] = function()
                lspconfig.bashls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
        })
    end,
}
