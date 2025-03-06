return {
    'theprimeagen/harpoon',
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd to harpoon", noremap = true })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "[E]xplore", noremap = true })

        vim.keymap.set("n", "<C-y>", function() ui.nav_file(1) end, { desc = "1st [Y]p", noremap = true })
        vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end, { desc = "2sd [T]op", noremap = true })
        vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "3rd [N]ext file", noremap = true })
        vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end, { desc = "4th [S]elected", noremap = true })

    end
}
