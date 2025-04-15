local api = vim.api
local devicons = require("nvim-web-devicons") -- Assuming nvim-web-devicons is installed
local ai = require("local_plugins.daemon.core.ai")
local context = require("local_plugins.daemon.core.context")
local context_state = require("local_plugins.daemon.core.context_state") -- Added context state

local M = {}

local sidebar_bufnr = nil
local sidebar_winid = nil
local original_winid = nil

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
	local content = {
		"AI: Hello! How can I help you today?",
		"",
		"Context:",
		"  ➕ Add File to Context... (Add File...)", -- Static Add action
	}

	-- Add files from state
	local files = context_state.get_files()
	for _, filepath in ipairs(files) do
		local filename = vim.fn.fnamemodify(filepath, ":~") -- Get path relative to home
		local ft = vim.fn.fnamemodify(filepath, ":e")
		local icon, hl = devicons.get_icon(filename, ft)
		table.insert(content, string.format("  %s %s (Remove from Context)", icon or "📄", filename))
	end

	-- Tool Example (kept for now)
	local tool_icon = ""
	table.insert(content, string.format("  %s Run `git status | cat` (Selectable Tool)", tool_icon))
	table.insert(content, "")
	table.insert(content, "--------------------")
	table.insert(content, "User Input> ")

	-- Update buffer content
	api.nvim_buf_set_option(bufnr, "modifiable", true)
	api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
	api.nvim_buf_set_option(bufnr, "modifiable", false)

	-- Clear old highlights before applying new ones
	api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

	-- Define/link highlight groups
	local selectable_hl_group = "DaemonSelectable"
	api.nvim_set_hl(0, selectable_hl_group, { link = "Underlined", default = true })
	api.nvim_set_hl(0, "DaemonRemoveContext", { link = "WarningMsg", default = true })
	api.nvim_set_hl(0, "DaemonAddContext", { link = "Question", default = true })
	-- DaemonToolCommand, DaemonToolOutput, DaemonUserInput, DaemonAIOutput are defined in show()

	-- Apply highlights line by line
	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		-- Highlight Add action
		if line:match("%(Add File%.%.%.%)$") then
			api.nvim_buf_add_highlight(bufnr, -1, "DaemonAddContext", i - 1, 0, -1)
		-- Highlight Remove actions
		elseif line:match("%(Remove from Context%)$") then
			api.nvim_buf_add_highlight(bufnr, -1, "DaemonRemoveContext", i - 1, 0, -1)
		-- Highlight Tool actions
		elseif line:match("%(Selectable Tool%)$") then
			api.nvim_buf_add_highlight(bufnr, -1, selectable_hl_group, i - 1, 0, -1)
		-- Highlight devicons for context files
		else
			for _, filepath in ipairs(files) do
				local filename = vim.fn.fnamemodify(filepath, ":~")
				local ft = vim.fn.fnamemodify(filepath, ":e")
				local icon, hl = devicons.get_icon(filename, ft)
				if icon and hl and line:find(icon, 1, true) == 3 then -- Check if icon is at the start (after spaces)
					api.nvim_buf_add_highlight(bufnr, -1, hl, i - 1, 2, 2 + #icon)
					break -- Only highlight first matching icon per line
				end
			end
		end
	end
end

-- Callback function for oil keymap
function M.__oil_select_and_close_callback()
	print("Oil custom keymap triggered! (__oil_select_and_close_callback)")
	local oil = require("oil")
	local context_state_local = require("local_plugins.daemon.core.context_state") -- Re-require

	local current_entry = oil.get_cursor_entry()
	if current_entry and current_entry.type == "file" then
		print("Inspecting current_entry:", vim.inspect(current_entry))
		-- Construct the full path
		local current_dir = oil.get_current_dir(0) -- 0 for current buffer
		if not current_dir then
			print("Error: Could not get current directory from oil.")
		else
			local full_path = vim.fs.joinpath(current_dir, current_entry.name)
			print("Adding file via keymap callback: " .. full_path)
			context_state_local.add_file(full_path)
			print("Refreshing sidebar content after add...")
			if sidebar_bufnr and api.nvim_buf_is_valid(sidebar_bufnr) then
				render_content(sidebar_bufnr)
			else
				print("Error: Sidebar buffer invalid, cannot refresh.")
			end
		end
	else
		print("No file entry under cursor.")
	end

	print("Closing oil window via keymap callback...")
	-- Use the top-level close function
	local oil_module = require("oil")
	if oil_module and oil_module.close then
		oil_module.close()
		print("Called oil.close().")
	else
		print("Error: Could not require or call oil.close().")
	end
end

-- Function to open oil for adding context files (explicitly delete default map)
local function open_oil_for_context()
	print("Attempting to open oil.nvim float...")
	local oil = require("oil")
	if not oil then print("Error: oil.nvim is not available."); return end

	oil.open_float(vim.fn.getcwd(), {
		border = "rounded",
		title = "Select Files (USE <Leader>s to Add)", -- Emphasize Leader+s
		-- No config.keymaps or on_submit here
	})

	-- Find the oil float window and buffer
	local oil_winid = nil
	local oil_bufnr = nil
	vim.defer_fn(function()
		print("Searching for oil float window...")
		for _, winid in ipairs(api.nvim_list_wins()) do
			local bufnr = api.nvim_win_get_buf(winid)
			if bufnr and api.nvim_buf_is_valid(bufnr) then
				local filetype = vim.bo[bufnr].filetype
				local win_config = api.nvim_win_get_config(winid)
				-- Check if it's an oil buffer in a floating window
				if filetype == 'oil' and win_config.relative and win_config.relative ~= '' then
					print("Found oil float window: " .. winid .. " with buffer: " .. bufnr)
					oil_winid = winid
					oil_bufnr = bufnr
					break
				end
			end
		end

		if not oil_bufnr then
			print("Error: Could not find the oil float buffer to set keymaps.")
			return
		end

		print("Setting keymaps for oil buffer: " .. oil_bufnr)
		-- Use nvim_buf_set_keymap for buffer-local maps
		local map_opts = { noremap = true, silent = true }
		local callback_cmd = ":lua require('local_plugins.daemon.ui.sidebar').__oil_select_and_close_callback()<CR>"

		-- Set our mappings (accepting <CR> might still be overridden)
		api.nvim_buf_set_keymap(oil_bufnr, 'n', '<CR>', callback_cmd, map_opts)
		api.nvim_buf_set_keymap(oil_bufnr, 'n', '<leader>s', callback_cmd, map_opts)

		print("Keymaps set for oil float. Recommend using <Leader>s.")
	end, 100) -- Defer slightly
end

-- Function to handle selection (Enter key)
local function handle_selection(bufnr)
	local context_state_local = require("local_plugins.daemon.core.context_state") -- Re-require inside

	local cursor_pos = api.nvim_win_get_cursor(sidebar_winid)
	local line_num = cursor_pos[1]
	local lines = api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)
	local line = lines[1]

	if not line then
		print("Could not get current line.")
		return
	end

	-- Match Add File action
	if line:match("%(Add File%.%.%.%)$") then
		open_oil_for_context()
		return
	end

	-- Match Remove File action
	local remove_match = line:match("^%s*[%s%S]+%s+(.+) %(Remove from Context%)$") -- Get path before marker
	if remove_match then
		-- The path is likely relative to home (from render_content), convert back
		local path_to_remove = vim.fn.expand(remove_match)
		context_state_local.remove_file(path_to_remove)
		render_content(bufnr) -- Refresh sidebar
		return
	end

	-- Match selectable file (Commented out - replaced by Remove logic)
	-- local file_path = line:match("^%S+%s+(.+) %(Selectable File%)$")
	-- if file_path then
	-- 	print("Opening file: " .. file_path)
	-- 	if original_winid and api.nvim_win_is_valid(original_winid) then
	-- 		api.nvim_set_current_win(original_winid)
	-- 		vim.cmd("edit " .. vim.fn.fnameescape(file_path))
	-- 	else
	-- 		print("Original window not found, opening in current window.")
	-- 		vim.cmd("edit " .. vim.fn.fnameescape(file_path))
	-- 	end
	-- 	return
	-- end

	-- Match selectable tool (Unchanged)
	local tool_desc = line:match("^%s*[%s%S]+%s+(.+) %(Selectable Tool%)$") -- Allow any icon
	if tool_desc then
		local command_to_run = tool_desc:match("`(.*)`")
		if command_to_run then
			print("Running command: " .. command_to_run)
			local output = vim.fn.systemlist(command_to_run)
			local output_line_count = #output
			api.nvim_buf_set_option(bufnr, "modifiable", true)
			local current_lines_tool = api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local input_line_num_tool = -1
			local input_line_prefix_tool = "User Input> "
			for i, l in ipairs(current_lines_tool) do
				if l:sub(1, #input_line_prefix_tool) == input_line_prefix_tool then
					input_line_num_tool = i
					break
				end
			end
			local tool_insert_idx = (input_line_num_tool > 0) and (input_line_num_tool - 2) or -1
			local lines_to_add = {}
			table.insert(lines_to_add, "")
			table.insert(lines_to_add, string.format("--> Running: `%s`", command_to_run))
			if output_line_count > 0 then table.insert(lines_to_add, output[1]) end
			api.nvim_buf_set_lines(bufnr, tool_insert_idx, tool_insert_idx, false, lines_to_add)
			local tool_cmd_line_idx = tool_insert_idx + 1
			api.nvim_buf_add_highlight(bufnr, -1, "DaemonToolCommand", tool_cmd_line_idx, 0, -1)
			if output_line_count > 0 then api.nvim_buf_add_highlight(bufnr, -1, "DaemonToolOutput", tool_cmd_line_idx + 1, 0, -1) end
			if output_line_count > 1 then
				local remaining_output = {}
				for i = 2, output_line_count do table.insert(remaining_output, output[i]) end
				local remaining_insert_idx = tool_insert_idx + #lines_to_add
				api.nvim_buf_set_lines(bufnr, remaining_insert_idx, remaining_insert_idx, false, remaining_output)
				for j = 0, #remaining_output - 1 do api.nvim_buf_add_highlight(bufnr, -1, "DaemonToolOutput", remaining_insert_idx + j, 0, -1) end
				local fold_start_line = remaining_insert_idx + 1
				local fold_end_line = remaining_insert_idx + #remaining_output
				if fold_start_line <= fold_end_line then
					api.nvim_command(string.format("%d,%dfold", fold_start_line, fold_end_line))
				end
			end
			api.nvim_buf_set_option(bufnr, "modifiable", false)
			print(string.format("Ran `%s` and added output to sidebar.", command_to_run))
			return
		end
	end

	-- Check if on input line (Modified call to gather_context)
	local input_line_prefix = "User Input> "
	if line:sub(1, #input_line_prefix) == input_line_prefix then
		vim.ui.input({ prompt = "Daemon Input: " }, function(input)
			if input == nil then print("Input cancelled.") return end
			if input == "" then print("Empty input discarded.") return end

			local current_lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local input_line_num = -1
			for i, l in ipairs(current_lines) do
				if l:sub(1, #input_line_prefix) == input_line_prefix then input_line_num = i; break end
			end
			if input_line_num == -1 then print("Error: Could not find input line."); return end

			local insert_idx = input_line_num - 2 -- Before separator
			api.nvim_buf_set_option(bufnr, "modifiable", true)
			local user_line_to_insert = string.format("User: %s", input)
			api.nvim_buf_set_lines(bufnr, insert_idx, insert_idx, false, { user_line_to_insert })
			api.nvim_buf_add_highlight(bufnr, -1, "DaemonUserInput", insert_idx, 0, -1)
			api.nvim_buf_set_option(bufnr, "modifiable", false)

			-- Gather context *without* sidebar bufnr
			local context_items = context.gather_context()

			-- Add thinking message
			local thinking_idx = insert_idx + 1
			local thinking_msg = "AI: Thinking..."
			api.nvim_buf_set_option(bufnr, "modifiable", true)
			api.nvim_buf_set_lines(bufnr, thinking_idx, thinking_idx, false, { thinking_msg })
			api.nvim_buf_add_highlight(bufnr, -1, "DaemonAIOutput", thinking_idx, 0, -1)
			api.nvim_buf_set_option(bufnr, "modifiable", false)

			-- Make async call
			ai.request_gemini_response(input, context_items, function(ai_response)
				if not api.nvim_buf_is_valid(bufnr) or not api.nvim_win_is_valid(sidebar_winid) then print("Sidebar closed."); return end
				local lines_to_insert = vim.split(ai_response, "\n", { plain = true })
				api.nvim_buf_set_option(bufnr, "modifiable", true)
				api.nvim_buf_set_lines(bufnr, thinking_idx, thinking_idx + 1, false, lines_to_insert)
				for i = 0, #lines_to_insert - 1 do api.nvim_buf_add_highlight(bufnr, -1, "DaemonAIOutput", thinking_idx + i, 0, -1) end
				api.nvim_buf_set_option(bufnr, "modifiable", false)
				print("AI response received.")
			end)
			print("Input processed, waiting for AI...")
		end)
		return
	end

	print("No actionable item found on this line.")
end

-- Autocommand group for sidebar buffer cleanup
local sidebar_augroup = nil

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
	api.nvim_win_set_option(sidebar_winid, "foldmethod", "manual") -- Enable manual folding
	api.nvim_win_set_option(sidebar_winid, "foldlevelstart", 99) -- Start with folds open

	-- Define highlight groups
	-- Link to existing groups for basic styling, can be customized by users later
	api.nvim_set_hl(0, "DaemonAIOutput", { link = "Comment", default = true })
	api.nvim_set_hl(0, "DaemonUserInput", { link = "String", default = true })
	api.nvim_set_hl(0, "DaemonToolCommand", { link = "Question", default = true })
	api.nvim_set_hl(0, "DaemonToolOutput", { link = "SpecialComment", default = true })
	-- DaemonSelectable is already defined in render_content

	-- Initial render
	render_content(bufnr)

	-- Apply highlight to initial AI message
	api.nvim_buf_add_highlight(bufnr, -1, "DaemonAIOutput", 0, 0, -1)

	-- Add keymaps specific to the sidebar buffer
	api.nvim_buf_set_keymap(bufnr, "n", "<CR>", ":lua require('local_plugins.daemon.ui.sidebar').__handle_selection()<CR>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(bufnr, "n", "q", ":lua require('local_plugins.daemon.ui.sidebar').__close()<CR>", { noremap = true, silent = true, desc = "Close Sidebar" })

	-- Setup autocommands for the buffer
	if not sidebar_augroup then
		sidebar_augroup = api.nvim_create_augroup("DaemonSidebar", { clear = true })
	end

	-- Ensure buffer starts non-modifiable
	api.nvim_buf_set_option(bufnr, "modifiable", false)

end

-- Internal function to be called by keymap
function M.__handle_selection()
	handle_selection(sidebar_bufnr)
end

-- Function to close the sidebar
local function close_sidebar()
    if sidebar_winid and api.nvim_win_is_valid(sidebar_winid) then
        api.nvim_win_close(sidebar_winid, true) -- Force close
        sidebar_winid = nil
        -- Maybe clear context state on close? context_state.clear_files()?
    end
    if original_winid and api.nvim_win_is_valid(original_winid) then
        api.nvim_set_current_win(original_winid)
        original_winid = nil
    end
end

-- Internal function to be called by keymap
function M.__close()
    close_sidebar()
end

return M 
