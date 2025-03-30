local jdtls = require("jdtls")

local config = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"), "-data", vim.fn.expand("~/.cache/nvim/jdtls/workspace/") },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", "mvnw", "gradlew" }, {upward = true})[1]),
}

-- Start JDTLS
jdtls.start_or_attach(config)

