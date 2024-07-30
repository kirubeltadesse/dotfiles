return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        --- Uncomment the two plugins below if you want to manage the language servers from neovim
        {
            'williamboman/mason.nvim',
            config = function()
                -- require("mason").setup()
                require('mason').setup({})
            end
        },
        {
            'williamboman/mason-lspconfig.nvim',
            config = function()
                require('mason-lspconfig').setup({
                    -- Replace the language servers listed here
                    -- with the ones you want to instal,l
                    -- FIXME:need to add this a lints 'cmake-language-server','cmakelint','cpplint','cpptools', 'java' 
                    ensure_installed = {'lua_ls', 'tsserver', 'pylsp', 'html', 'rust_analyzer'},
                    handlers = {
                        function(server_name)
                            require('lspconfig')[server_name].setup({})
                        end,
                    }
                })

            end
        },

        -- Autocompletion
        {
            'neovim/nvim-lspconfig',
            config = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup({})
                lspconfig.tsserver.setup({})

                vim.keymap.set("n", "gd",  function() vim.lsp.buf.definition() end, {})
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {})
                -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, {})
                -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                -- vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end
        },
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
    },
    event= 'VeryLazy',
    config = function() -- This is the function that  runs, AFTER loading
        local lsp_zero = require('lsp-zero')

        lsp_zero.preset("recommended")
        local cmp_action = require('lsp-zero').cmp_action()
        -- local cmp_select = {behavior = cmp.SelectBehavior.Select}
        local cmp = require('cmp')
        cmp.setup({
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-n>'] = cmp_action.luasnip_jump_forward(),
                ['<C-p>'] = cmp_action.luasnip_jump_backward(),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
        })


        lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({buffer = bufnr})
            local opts = {buffer = bufnr, remap = false}



        end)


    end
}

-- lsp_zero.set_prefrences({
    -- sign_icons = { }
    -- })

    -- Setup the custom mappings
    -- lsp_zero.setup_nvim_cmp({
        -- 	mapping = cmp_mappings
        -- })
