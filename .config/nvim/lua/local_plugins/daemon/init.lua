-- Main file for the daemon.nvim plugin
local M = {}

-- Require necessary modules early if needed outside setup
local sidebar = require("local_plugins.daemon.ui.sidebar")

--- Shows the Daemon sidebar.
-- Can be called directly via Lua or mapped to a keybinding.
function M.show()
	sidebar.show()
end

-- Placeholder setup function
-- This will be called by the plugin manager (lazy.nvim)
function M.setup(opts)
	-- TODO: Initialize plugin state, load modules, set up commands/autocmds
	-- Load other submodules if needed within setup
	-- Example: local chat = require("local_plugins.daemon.lua.chat")

	-- Example: Define commands inside setup if they depend on setup completion
	-- vim.api.nvim_create_user_command("DaemonChat", chat.open_chat_window, {
	--   desc = "Open the Daemon chat window",
	-- })

	-- Create the command to call M.show
	vim.api.nvim_create_user_command("DaemonShowSidebar", M.show, {
		desc = "Show the Daemon sidebar",
	})

	-- Setup function doesn't need to return the show function anymore
end

return M

