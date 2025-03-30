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
                "clangd",
                "pyright",
                "ruff",
                "lua_ls",
                "rust_analyzer",
                "bashls",
            },
            auto_install = true,
            handlers = {
                jdtls = function() end, --Disable masons's jdtls setup
            },
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
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    cmd = { "clangd" },
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
                lspconfig.ruff.setup({
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

            ["bashls"] = function()
                lspconfig.bashls.setup({
                    capabilities = capabilities,
                })
            end,
            require('sonarlint').setup({
               server = {
                  cmd = {
                     'sonarlint-language-server',
                     -- Ensure that sonarlint-language-server uses stdio channel
                     '-stdio',
                     '-analyzers',
                     -- paths to the analyzers you need, using those for python and java in this example
                     vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
                     vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
                     vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
                  },
                  -- All settings are optional
                  settings = {
                     -- The default for sonarlint is {}, this is just an example
                     sonarlint = {
                        rules = {
                           ['typescript:S101'] = { level = 'on', parameters = { format = '^[A-Z][a-zA-Z0-9]*$' } },
                           ['typescript:S103'] = { level = 'on', parameters = { maximumLineLength = 180 } },
                           ['typescript:S106'] = { level = 'on' },
                           ['typescript:S107'] = { level = 'on', parameters = { maximumFunctionParameters = 7 } }
                        }
                     }
                  }
               },
               filetypes = {
                  -- Tested and working
                  'python',
                  'cpp',
                  -- Requires nvim-jdtls, otherwise an error message will be printed
                  'java',
               }
            }),

            ["jdtls"] = function()
                -- jdtls is configured separately in java.lua file
            end,
        })
    end,
}
