require("swarmies.remap")
require("swarmies.set")
print("hello from swarmies")


vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    command = "setlocal modifiable",
})

