return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                require("none-ls.diagnostics.cpplint"),
                require("none-ls.diagnostics.eslint_d"),
                require("none-ls.diagnostics.ruff"),
                require("none-ls.code_actions.eslint"),
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.clang_format.with({
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    extra_args = { BasedOnStyle = "LLVM", IndentWidth = 4, TabWidth = 4, UseTab = "Always" },
                }),
            },
        })
        vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "LSP Format Buffer" })
    end,
}
