return {
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			local M = {}
			local cache_vars = {}
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

			local java_cmds_group = vim.api.nvim_create_augroup("java_cmds", { clear = true })

			-- Function to get necessary jdtls paths
			local function get_jdtls_paths()
				if cache_vars.paths then
					return cache_vars.paths
				end
				local path = {}
				local home = os.getenv("HOME")

				path.data_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace"
				path.lombok_path = home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar"

				local mason_jdtls = require("mason-registry").get_package("jdtls"):get_install_path()
				path.launcher_jar = vim.fn.glob(mason_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")

				-- Platform-specific config paths
				if vim.fn.has("mac") == 1 then
					path.platform_config = mason_jdtls .. "/config_mac"
				elseif vim.fn.has("unix") == 1 then
					path.platform_config = mason_jdtls .. "/config_linux"
				end

				path.bundles = {}

				-- Java test and debug packages (optional)
				local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()
				local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
				if java_test_bundle[1] ~= "" then
					vim.list_extend(path.bundles, java_test_bundle)
				end

				local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
				local java_debug_bundle = vim.split(
					vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
					"\n"
				)
				if java_debug_bundle[1] ~= "" then
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

				-- Clear any existing autocommands in the group
				vim.api.nvim_clear_autocmds({ group = java_cmds_group, buffer = bufnr })

				vim.api.nvim_create_autocmd("BufWritePost", {
					buffer = bufnr,
					group = java_cmds_group,
					callback = function()
						vim.lsp.codelens.refresh()
					end,
					desc = "Refresh CodeLens on buffer write",
				})
			end

			local function register_cleanup_on_detach(bufnr)
				vim.api.nvim_create_autocmd("LspDetach", {
					buffer = bufnr,
					group = java_cmds_group,
					once = true,
					callback = function(args)
						vim.api.nvim_clear_autocmds({ group = java_cmds_group, buffer = args.bufnr })
						vim.notify(
							"🧹 Cleaned up java_cmds autocommands for buffer " .. args.buf,
							vim.log.levels.DEBUG
						)
					end,
					desc = "Cleanup on LspDetach",
				})
			end

			-- Function to enable Debugger
			local function enable_debugger(bufnr)
				require("jdtls").setup_dap({ hotcodereplace = "auto" })
				require("jdtls.dap").setup_dap_main_class_configs()

				local opts = { buffer = bufnr }
				vim.keymap.set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
				vim.keymap.set("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
			end

			-- Function for on_attach for jdtls
			local function jdtls_on_attach(client, bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true }

				-- jdtls specific keybindings
				vim.keymap.set("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
				vim.keymap.set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
				vim.keymap.set("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
				vim.keymap.set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
				vim.keymap.set("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
				vim.keymap.set("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
				vim.keymap.set("n", "vc", "<cmd>lua require('jdtls').test_class()<cr>", opts)

				vim.notify("📌 jdtls_on_attach() called!", vim.log.levels.INFO)
				if features.debugger then
					enable_debugger(bufnr)
				end

				if features.codelens then
					-- Explicity enable CodeLens after attaching
					client.server_capabilities.documentFormattingProvider = false -- Disable formatting from jdtls
					client.server_capabilities.codelensProvider = { resolveProvider = true }
					if client.server_capabilities.codelensProvider then
						enable_codelens(bufnr)
					else
						vim.notify("CodeLens is not supported by the server.", vim.log.levels.INFO)
					end
				end

				-- Manually triggering my LspAttach callback for `jdtls`
				vim.api.nvim_exec_autocmds("LspAttach", { group = java_cmds_group, buffer = bufnr })

				-- Register cleanup on LspDetach
				register_cleanup_on_detach(bufnr)
			end

			-- jdtls setup
			function M.jdtls_setup()
				-- vim.notify("🚀 Running jdtls_setup() for Java!", vim.log.levels.INFO)

				local status, jdtls = pcall(require, "jdtls")
				if not status then
					vim.notify("❌ jdtls not found. Please install it using Mason.", vim.log.levels.ERROR)
					return
				end

				local path = get_jdtls_paths()

				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				local workspace_dir = path.data_dir .. "/" .. project_name .. "_workspace"

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				local cmp_ok, blink_cmp = pcall(require, "blink.cmp")
				if cmp_ok then
					capabilities = blink_cmp.get_lsp_capabilities(capabilities)
				else
					vim.notify("blink_cmp not found. Falling back to default capabilities.", vim.log.levels.WARN)
				end
				-- capabilities.textDocument.completion.completionItem.snippetSupport = true

				local cmd = {
					vim.fn.expand("~/.sdkman/candidates/java/current/bin/java"),
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-javaagent:" .. path.lombok_path,
					"-jar",
					path.launcher_jar,
					"-configuration",
					path.platform_config,
					"-data",
					workspace_dir,
				}

				local lsp_settings = {

					java = {
						format = {
							enabled = false,
							-- TODO: download the google-java-format jar and set it here
							-- settings = {
							--     url = "file:///" .. vim.fn.expand("~/.config/nvim/lua/plugins/java/google-java-format-1.7-all-deps.jar"),
							--     profile = "GoogleStyle",
							-- },
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
								vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m",
								codeLens = { enabled = true }, -- Explicitly enable CodeLens
							},
						},
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						referencesCodeLens = { enabled = true },
						references = { includeDecompiledSources = true },
						inlayHints = {
							parameterNames = { enabled = true },
							variableTypes = { enabled = true },
							variableNames = { enabled = true },
						},
						signatureHelp = { description = { enabled = true } },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
							},
						},
						extendedClientCapabilities = jdtls.extendedClientCapabilities,
					},
				}

				jdtls.start_or_attach({
					cmd = cmd,
					root_dir = jdtls.setup.find_root(root_markers),
					settings = lsp_settings,
					on_attach = jdtls_on_attach,
					capabilities = capabilities,
					-- init_options = { bundles = path.bundles }, ignore or remove this line to disable
				})
			end

			-- Automatically run jdtls setup when opening a Java file
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					-- vim.notify("📌 Java FileType detected. Running jdtls_setup()...", vim.log.levels.INFO)
					M.jdtls_setup()
				end,
			})
			return M
		end,
	},
}
