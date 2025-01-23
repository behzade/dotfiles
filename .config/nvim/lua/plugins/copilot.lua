return {
    {
        "David-Kunz/gen.nvim",
        opts = {
            model = "phi3", -- The default model to use.
        }
    },
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
            })
        end,
    },
}
