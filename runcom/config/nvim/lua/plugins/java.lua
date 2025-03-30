return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local M = {}
            local cache_vars = {}
            local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }

            -- Function to get necessary jdtls paths
            local function get_jdtls_paths()
                if cache_vars.paths then return cache_vars.paths end
                local path = {}

                path.data_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace'

                local mason_jdtls = require('mason-registry').get_package('jdtls'):get_install_path()
                path.launcher_jar = vim.fn.glob(mason_jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar')

                -- Platform-specific config paths
                if vim.fn.has('mac') == 1 then
                    path.platform_config = mason_jdtls .. '/config_mac'
                elseif vim.fn.has('unix') == 1 then
                    path.platform_config = mason_jdtls .. '/config_linux'
                end

                path.bundles = {}

                -- Java test and debug packages (optional)
                local java_test_path = require('mason-registry').get_package('java-test'):get_install_path()
                local java_test_bundle = vim.split(
                    vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n'
                )
                if java_test_bundle[1] ~= '' then
                    vim.list_extend(path.bundles, java_test_bundle)
                end

                local java_debug_path = require('mason-registry').get_package('java-debug-adapter'):get_install_path()
                local java_debug_bundle = vim.split(
                    vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'
                )
                if java_debug_bundle[1] ~= '' then
                    vim.list_extend(path.bundles, java_debug_bundle)
                end

                -- Updated runtimes to use SDKMAN
                path.runtimes = {
                    {
                        name = "JavaSE-17",
                        path = vim.fn.expand("~/.sdkman/candidates/java/current"),
                    },
                }

                cache_vars.paths = path
                return path
            end

            -- Features: CodeLens and Debugger
            local features = {
                codelens = true,
                debugger = true,
            }

            -- Function to enable CodeLens
            local function enable_codelens(bufnr)
                vim.lsp.codelens.refresh()

                vim.api.nvim_create_autocmd('BufWritePost', {
                    buffer = bufnr,
                    group = 'java_cmds',
                    callback = function()
                        vim.lsp.codelens.refresh()
                    end,
                })
            end

            -- Function to enable Debugger
            local function enable_debugger(bufnr)
                require('jdtls').setup_dap({ hotcodereplace = 'auto' })
                require('jdtls.dap').setup_dap_main_class_configs()

                local opts = { buffer = bufnr }
                vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
                vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
            end

            -- Function for on_attach for jdtls
            local function jdtls_on_attach(client, bufnr)
                vim.notify("📌 jdtls_on_attach() called!", vim.log.levels.INFO)
                if features.debugger then
                    enable_debugger(bufnr)
                end

                if features.codelens then
                    -- Explicity enable CodeLens after attaching
                    client.server_capabilities.documentFormattingProvider = false -- Disable formatting from jdtls
                    client.server_capabilities.codelensProvider = { resolveProvider = true }
                    enable_codelens(bufnr)
                end

                -- Manually triggering my LspAttach callback for `jdtls`
                vim.api.nvim_exec_autocmds('LspAttach', { group = 'java_cmds', buffer = bufnr })
            end

            -- jdtls setup
            function M.jdtls_setup()
                -- vim.notify("🚀 Running jdtls_setup() for Java!", vim.log.levels.INFO)

                local jdtls = require('jdtls')
                local path = get_jdtls_paths()

                local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
                local workspace_dir = path.data_dir .. '/' .. project_name .. '_workspace'

                local capabilities = vim.lsp.protocol.make_client_capabilities()
                local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
                if cmp_ok then
                    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
                end

                local cmd = {
                    vim.fn.expand("~/.sdkman/candidates/java/current/bin/java"),
                    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                    '-Dosgi.bundles.defaultStartLevel=4',
                    '-Declipse.product=org.eclipse.jdt.ls.core.product',
                    '-Dlog.protocol=true',
                    '-Dlog.level=ALL',
                    '-Xms1g',
                    '--add-modules=ALL-SYSTEM',
                    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                    '-jar', path.launcher_jar,
                    '-configuration', path.platform_config,
                    '-data', workspace_dir,
                }

                local lsp_settings = {

                    java = {
                        format = {
                            enabled = false,
                            settings = {
                                url = "file:///" .. vim.fn.expand("~/.config/nvim/lua/plugins/java/google-java-format-1.7-all-deps.jar"),
                                profile = "GoogleStyle",
                            },
                        },
                        -- Enable codeLens for organizing imports
                        codeLens = {
                            enable = true,
                            resolveProvider = true,
                            references = true,
                            testForCodeLens = true,
                            implementations = true,
                            typeHierarchy = true,
                            -- organizeImports = true,  -- This is now handled by the keymap
                        },
                        jdt = {
                            ls = {
                                vmargs =
                                "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m",
                                codeLens = { enabled = true }, -- Explicitly enable CodeLens
                            }
                        },
                        eclipse = { downloadSources = true },
                        maven = { downloadSources = true },
                        signatureHelp = { description = { enabled = true } },
                        completion = { favoriteStaticMembers = { 'org.junit.jupiter.api.Assertions.*', 'java.util.Objects.requireNonNull' } },
                    },
                    extendedClientCapabilities = jdtls.extendedClientCapabilities,
                }

                jdtls.start_or_attach({
                    cmd = cmd,
                    root_dir = jdtls.setup.find_root(root_markers),
                    settings = lsp_settings,
                    on_attach = jdtls_on_attach,
                    capabilities = capabilities,
                    init_options = { bundles = path.bundles },
                })
            end

            -- Automatically run jdtls setup when opening a Java file
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'java',
                callback = function()
                    -- vim.notify("📌 Java FileType detected. Running jdtls_setup()...", vim.log.levels.INFO)
                    M.jdtls_setup()
                end,
            })
            return M
        end,
    }
}

