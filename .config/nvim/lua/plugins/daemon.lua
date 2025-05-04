return {
    {
        dir = '~/Projects/personal/plugin-workshop/daemon',

        config = function()
            require('daemon').setup()
        end,

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",

        }
    }
}
