return {
    "danarth/sonarlint.nvim",
    config = function()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server"
        require("sonarlint").setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
            server = {
                -- name = "sonarlint",
                cmd = {
                    "java",
                    "-Dsonar.verbose=true",
                    "-Dsonar.log.level=DEBUG",
                    "-jar", mason_path .. "/extension/server/sonarlint-ls.jar",
                    "-stdio",
                    "-analyzers", mason_path .. "/extension/analyzers/sonarjava.jar",
                },
            },
            settings = {
            },
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
