-- lua/local_plugins/daemon/core/context_state.lua
local M = {}

-- Stores the absolute paths of files added to the context
local context_files = {}

--- Adds a file path to the context.
-- Converts the path to absolute before adding.
-- @param filepath string The path to add.
function M.add_file(filepath)
    if not filepath or filepath == "" then
        print("Error: Cannot add empty file path to context.")
        return
    end
    local abs_path = vim.fn.fnamemodify(filepath, ":p")
    -- Avoid duplicates
    for _, existing_path in ipairs(context_files) do
        if existing_path == abs_path then
            print("Info: File already in context: " .. abs_path)
            return
        end
    end
    table.insert(context_files, abs_path)
    print("Added to context: " .. abs_path)
    -- TODO: Trigger sidebar refresh?
end

--- Removes a file path from the context.
-- @param filepath string The path to remove (can be relative or absolute).
function M.remove_file(filepath)
    if not filepath or filepath == "" then
        print("Error: Cannot remove empty file path from context.")
        return
    end
    local abs_path_to_remove = vim.fn.fnamemodify(filepath, ":p")
    local found_idx = -1
    for i, existing_path in ipairs(context_files) do
        if existing_path == abs_path_to_remove then
            found_idx = i
            break
        end
    end

    if found_idx > 0 then
        table.remove(context_files, found_idx)
        print("Removed from context: " .. abs_path_to_remove)
        -- TODO: Trigger sidebar refresh?
    else
        print("Warning: File not found in context for removal: " .. abs_path_to_remove)
    end
end

--- Gets the list of absolute file paths currently in the context.
-- @return table A list of strings (absolute paths).
function M.get_files()
    return context_files
end

--- Clears all files from the context.
function M.clear_files()
    context_files = {}
    print("Context files cleared.")
    -- TODO: Trigger sidebar refresh?
end

return M 