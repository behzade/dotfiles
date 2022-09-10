return function()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<A-t>"] = require('telescope.actions.layout').toggle_preview,
                },
            },
            layout_strategy = "center",
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
                center = {
                    anchor = "S",
                    width = 0.9,
                }
            },
        },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("file_browser")
end
