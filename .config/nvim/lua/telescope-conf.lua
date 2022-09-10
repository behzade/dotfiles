return function()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
                },
            },
            preview = {
                hide_on_startup = true
            },
            layout_strategy = "center",
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
                center = { width = 0.9 }
            },
        },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("file_browser")
end
