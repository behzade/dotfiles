--[[
  A Lua module to get a list of filenames from a directory without their extensions.
  This is useful for dynamically reading configuration files, like language servers.
--]]

local M = {}

--- Gets a list of files inside a specified directory, removing their file extensions.
--
-- @param dir_name string The name of the directory inside your lua config folder.
--                       For example, "servers" to target "~/.config/nvim/lua/servers".
-- @return table A table containing the filenames without extensions, or an empty table if the directory doesn't exist.
function M.get_files_in_config_dir(dir_name)
  -- Construct the full path to the target directory within the Neovim config.
  -- vim.fn.stdpath('config') usually resolves to ~/.config/nvim
  local path = vim.fn.stdpath('config') .. '/lua/' .. dir_name

  -- A table to store the final list of server names.
  local files_no_ext = {}

  -- Use pcall (protected call) to safely handle cases where the directory might not exist.
  -- vim.fn.isdirectory() returns 1 if it is a directory, 0 otherwise.
  local ok, _ = pcall(vim.fn.isdirectory, path)
  if not ok or vim.fn.isdirectory(path) ~= 1 then
    vim.notify('Directory not found: ' .. path, vim.log.levels.WARN)
    return files_no_ext -- Return an empty table
  end

  -- vim.fn.readdir() returns a list of files and directories at the given path.
  local files = vim.fn.readdir(path)

  if files == nil then
    return files_no_ext -- Return empty table if directory is empty or unreadable
  end

  -- Iterate over the list of entries found in the directory.
  for _, file_name in ipairs(files) do
    local full_path = path .. '/' .. file_name
    -- We only want files, so we check that the entry is not a directory.
    if vim.fn.isdirectory(full_path) == 0 then
      -- vim.fn.fnamemodify(filename, ":r") is a robust way to get the
      -- filename without its extension (the 'root' part of the name).
      -- Example: "lua_ls.lua" becomes "lua_ls"
      local name_without_extension = vim.fn.fnamemodify(file_name, ':r')
      table.insert(files_no_ext, name_without_extension)
    end
  end

  return files_no_ext
end

-- Example of how to use the function.
-- To test this, you would create a folder like ~/.config/nvim/lua/servers/
-- and add some files like: lua_ls.lua, pyright.lua, etc.

-- local server_names = M.get_files_in_config_dir('servers')

-- The following command will print the table contents to the Neovim message area.
-- vim.notify(vim.inspect(server_names))
-- Expected output might look like:
-- { "lua_ls", "pyright" }

return M

