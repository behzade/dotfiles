return function()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<A-t>"] = require('telescope.actions.layout').toggle_preview,
                },
            },
            layout_strategy = "bottom_pane",
            sorting_strategy = "ascending",
            layout_config = {
                height = 0.6
            },
            border = true
        },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("projects")
end
