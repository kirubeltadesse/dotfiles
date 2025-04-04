return {
    "danarth/sonarlint.nvim",
    config = function()
        local mason_path = require("mason-registry").get_package("sonarlint-language-server"):get_install_path()
        require("sonarlint").setup({
            server = {
                cmd = { "java", "-jar", mason_path .. "/extension/server/sonarlint-ls.jar", '-stdio',
                '-analyzers', mason_path .. "/extension/analyzers/sonarjava.jar" },
                -- args = { "analyzar", "--format", "json", "--path", "$FILENAME" },
            },
            filetypes = { "java" },
        })
    end,
}
