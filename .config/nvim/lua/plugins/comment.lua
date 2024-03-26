return {
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup()
        end
    },
    {
        'folke/todo-comments.nvim',
        config = function()
            require("todo-comments").setup({})
        end,
    },
}
