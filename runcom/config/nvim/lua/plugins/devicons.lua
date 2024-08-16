return {
    'nvim-tree/nvim-web-devicons',
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require('tiny-devicons-auto-colors').setup()
        require('nvim-web-devicons').setup {}
    end,
    {
        "mskelton/termicons.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        build = false,
        config = function()
            require("termicons").setup()
        end
    }
}
