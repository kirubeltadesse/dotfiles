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
            ensure_installed = {"pylsp", "html", "tsserver", "lua_ls", "rust_analyzer"},
            -- auto_install = true,
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
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }
            end,
        }
    end,
}

