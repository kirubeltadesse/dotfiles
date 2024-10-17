return {
    "smjonas/inc-rename.nvim",
    config = function()
        -- Set up the inc-rename plugin
        require("inc_rename").setup()

        -- Define the rename keymap
        vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Rename current word" })
    end
}
