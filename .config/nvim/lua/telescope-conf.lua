local layout_actions = require("telescope.actions.layout")
local init = function()
	require("telescope").setup({
		defaults = {
			mappings = {
				i = { ["<c-space>"] = layout_actions.toggle_preview },
			},
			-- preview = {
			-- 	hide_on_startup = true,
			-- },
            layout_strategy = "center",
            sorting_strategy = "ascending",
            layout_config = {
                prompt_position = "top",
                center = { width = 0.9 }
            }
		},
	})
	require("telescope").load_extension("fzy_native")
	require("telescope").load_extension("projects")
end

return {
	init = init,
}
