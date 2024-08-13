return {
    'nvim-tree/nvim-web-devicons',
    config = function()
        require('nvim-web-devicons').setup {}
    end
    --    "kyazdani42/nvim-web-devicons",
    --    "rachartier/tiny-devicons-auto-colors.nvim",
    --    dependencies = {
    --        "nvim-tree/nvim-web-devicons"
    --    },
    --    config = function()
    --        require('tiny-devicons-auto-colors').setup()
    --    end,
    --    {
    --        "mskelton/termicons.nvim",
    --        requires = { "nvim-tree/nvim-web-devicons" },
    --        build = false,
    --        config = function()
    --            require("termicons").setup()
    --        end
    --    }
}
