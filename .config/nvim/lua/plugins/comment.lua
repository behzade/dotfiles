return {
    "numToStr/Comment.nvim",
    {
        'folke/todo-comments.nvim',
        config = function()
            require("todo-comments").setup({})
        end,
    },
}
