local api = vim.api
local devicons = require("nvim-web-devicons") -- Assuming nvim-web-devicons is installed

local M = {}

local sidebar_bufnr = nil
local sidebar_winid = nil
local original_winid = nil -- Store the window ID active before sidebar opened

-- Placeholder content generation
local function get_placeholder_content()
	local content = {
		"AI: Hello! How can I help you today?",
		"",
		"Context:",
	}
	-- File Example
	local file_icon, file_hl = devicons.get_icon_by_filetype("lua")
	table.insert(content, string.format("%s %s (Selectable File)", file_icon or "?", "lua/local_plugins/daemon/init.lua"))

	-- Tool Example
	local tool_icon = "" -- Example: Gear icon
	table.insert(content, string.format("%s %s (Selectable Tool)", tool_icon, "Run `git status | cat`"))
	table.insert(content, "")
	table.insert(content, "--------------------")
	table.insert(content, "User Input> ") -- Placeholder for input line

	return content
end

-- Function to create or find the sidebar buffer
local function get_sidebar_buffer()
	if sidebar_bufnr and api.nvim_buf_is_valid(sidebar_bufnr) then
		return sidebar_bufnr
	end
	sidebar_bufnr = api.nvim_create_buf(false, true) -- nofile, scratch
	api.nvim_buf_set_option(sidebar_bufnr, "bufhidden", "hide")
	api.nvim_buf_set_option(sidebar_bufnr, "swapfile", false)
	api.nvim_buf_set_option(sidebar_bufnr, "filetype", "DaemonSidebar") -- For potential syntax/conceal
	return sidebar_bufnr
end

-- Function to render the content and highlights
local function render_content(bufnr)
	local content = get_placeholder_content()
	api.nvim_buf_set_lines(bufnr, 0, -1, false, content)

	-- Add placeholder highlights for selectable items (adjust highlight group later)
	local selectable_hl_group = "DaemonSelectable" -- Define this highlight group later
	api.nvim_set_hl(0, selectable_hl_group, { link = "Underlined", default = true }) -- Link to Underlined for visibility

	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("(Selectable File)") or line:match("(Selectable Tool)") then
			api.nvim_buf_add_highlight(bufnr, -1, selectable_hl_group, i - 1, 0, -1)
		end
		-- Add devicons highlights
		local file_icon, file_hl = devicons.get_icon_by_filetype("lua")
		if file_icon and line:match(file_icon) then
			api.nvim_buf_add_highlight(bufnr, -1, file_hl, i - 1, 0, #file_icon)
		end
	end
end

-- Function to handle selection (Enter key)
local function handle_selection(bufnr)
	local cursor_pos = api.nvim_win_get_cursor(sidebar_winid) -- Assuming sidebar_winid is accessible
	local line_num = cursor_pos[1]
	local lines = api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)
	local line = lines[1]

	if not line then
		print("Could not get current line.")
		return
	end

	-- Match selectable file
	-- Pattern: Start ^ Icon(NonSpace+) Space+ CapturePath(.+) Space (Selectable File) End $
	local file_path = line:match("^%S+%s+(.+) %(Selectable File%)$")
	if file_path then
		print("Opening file: " .. file_path)
		-- Switch back to the original window before opening the file
		if original_winid and api.nvim_win_is_valid(original_winid) then
			api.nvim_set_current_win(original_winid)
			vim.cmd("edit " .. vim.fn.fnameescape(file_path))
			-- Close sidebar after opening? Or keep it open? Keeping open for now.
			-- If keeping open, maybe focus back to sidebar? For now, focus stays on opened file.
			-- close_sidebar() -- Uncomment to close after opening file
		else
			print("Original window not found, opening in current window.")
			vim.cmd("edit " .. vim.fn.fnameescape(file_path))
		end
		return
	end

	-- Match selectable tool
	-- Pattern 1: Capture the descriptive part
	local tool_desc = line:match("^%S+%s+(.+) %(Selectable Tool%)$")
	if tool_desc then
		-- Pattern 2: Extract command from within backticks in the description
		local command_to_run = tool_desc:match("`(.*)`")
		if command_to_run then
			print("Running command: " .. command_to_run)

			-- Append command and output to the sidebar buffer
			api.nvim_buf_set_option(bufnr, "modifiable", true)
			api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", string.format("--> Running: `%s`", command_to_run) })
			local output = vim.fn.systemlist(command_to_run)
			api.nvim_buf_set_lines(bufnr, -1, -1, false, output)
			api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "--------------------" })
			-- TODO: Maybe move cursor to end of buffer?
			api.nvim_buf_set_option(bufnr, "modifiable", false)

			return
		end
	end

	-- Check if on input line (simple check for now)
	if line:match("User Input> ") then
		print("On input line - TODO: Handle input")
		-- TODO: Enter insert mode?
	else
		print("No selectable item on this line.")
	end
end


--- Creates and displays the sidebar floating window
function M.show()
	local bufnr = get_sidebar_buffer()

	-- Store the current window before opening the sidebar
	local current_win = api.nvim_get_current_win()

	if sidebar_winid and api.nvim_win_is_valid(sidebar_winid) then
		-- Sidebar already open, just focus it
		api.nvim_set_current_win(sidebar_winid)
		original_winid = current_win -- Update original window in case it changed
		render_content(bufnr) -- Re-render content (might need smarter updates later)
		return
	end

	-- Store the original window ID
	original_winid = current_win

	-- Calculate window dimensions and position (e.g., right side)
	local width = math.floor(api.nvim_get_option("columns") * 0.4) -- 40% width
	local height = api.nvim_get_option("lines") - 2 -- Full height minus cmdline
	local row = 0
	local col = api.nvim_get_option("columns") - width

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded", -- Or single, double, etc.
		focusable = true,
	}

	sidebar_winid = api.nvim_open_win(bufnr, true, win_opts) -- focus=true
	api.nvim_win_set_option(sidebar_winid, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder") -- Basic highlighting
	api.nvim_win_set_option(sidebar_winid, "cursorline", true) -- Show cursor line

	-- Initial render
	render_content(bufnr)

	-- Add keymaps specific to the sidebar buffer
	api.nvim_buf_set_keymap(bufnr, "n", "<CR>", ":lua require('local_plugins.daemon.ui.sidebar').__handle_selection()<CR>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua require('local_plugins.daemon.ui.sidebar').__close()<CR>", { noremap = true, silent = true, desc = "Close Sidebar" })

end

-- Internal function to be called by keymap
-- Needs to be exposed on the module table temporarily for the keymap string
function M.__handle_selection()
	handle_selection(sidebar_bufnr)
end

-- Function to close the sidebar
local function close_sidebar()
    if sidebar_winid and api.nvim_win_is_valid(sidebar_winid) then
        api.nvim_win_close(sidebar_winid, true) -- Force close
        sidebar_winid = nil
        -- Optional: Clear buffer? sidebar_bufnr = nil?
    end
end

-- Internal function to be called by keymap
function M.__close()
    close_sidebar()
end

return M 
