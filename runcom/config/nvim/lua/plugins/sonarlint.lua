return {
    "danarth/sonarlint.nvim",
    config = function()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server"
        local lspconfig_util = require("lspconfig.util")
        -- Find the project root using root_pattern
        local root_dir = lspconfig_util.root_pattern(".sonarlint")(vim.fn.expand("%:p")) or vim.loop.cwd()

        require("sonarlint").setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
            server = {
                cmd = {
                    "java",
                    "-Dsonar.verbose=true",
                    "-Dsonar.log.level=DEBUG",
                    "-Dsonarlint.connect.mode.file=" .. root_dir .. "/.sonarlint/connectMode.json",
                    "-jar", mason_path .. "/extension/server/sonarlint-ls.jar",
                    "-stdio",
                    "-analyzers", mason_path .. "/extension/analyzers/sonarjava.jar",
                },
            },
            settings = {},
            handlers = {
                ["textDocument/codeAction"] = function(_, result, ctx, config)
                    if not result or vim.tbl_isempty(result) then
                        vim.notify("No code actions available from SonarLint", vim.log.levels.INFO)
                        return
                    end
                    vim.lsp.handlers["textDocument/codeAction"](nil, result, ctx, config)
                end,
                ["sonarlint/isOpenInEditor"] = function(_, _, params)
                    return {
                        isOpen = true,
                        filePath = params.filePath,
                    }
                end,
            },
            filetypes = { "java" },
        })
    end,
}
