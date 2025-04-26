return {
    "danarth/sonarlint.nvim",
    config = function()
        require("sonarlint").setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            server = {
                -- name = "sonarlint",
                cmd = {
                    "java",
                    "-Dsonar.verbose=true",
                    "-Dsonar.log.level=DEBUG",
                    "-jar", vim.fn.expand("$MASON/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar"),
                    "-stdio",
                    "-analyzers", vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
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
