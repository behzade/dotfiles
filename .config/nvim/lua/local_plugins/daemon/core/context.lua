-- lua/local_plugins/daemon/core/context.lua
local M = {}
local context_state = require("local_plugins.daemon.core.context_state")

--- Gathers various context information relevant for the AI.
-- Reads current buffer and files specified in the context state.
-- @return table A list of context items.
function M.gather_context()
    local context_items = {}
    local max_len = 5000 -- Limit context length for each item (adjust as needed)
    local api = vim.api

    -- 1. Current Buffer Content
    local current_buf_handle = api.nvim_get_current_buf()
    -- Avoid adding if it's an oil buffer or other special buffer types?
    -- Maybe check bufname or buftype?
    local buf_name = vim.fn.bufname(current_buf_handle) or "[No Name]"
    local filetype = vim.bo[current_buf_handle].filetype or "text"
    local lines = api.nvim_buf_get_lines(current_buf_handle, 0, -1, false)
    local buffer_content = table.concat(lines, "\n")

    if #buffer_content > 0 then
        if string.len(buffer_content) > max_len then
            buffer_content = string.sub(buffer_content, 1, max_len) .. "\n... (truncated)"
        end
        local context_text = string.format(
            "Context: Current buffer (%s) content:\n```%s\n%s\n```",
            buf_name,
            filetype,
            buffer_content
        )
        table.insert(context_items, { role = "user", text = context_text })
    end

    -- 2. Files listed in the Context State
    local files_in_context = context_state.get_files()
    for _, file_path in ipairs(files_in_context) do
        -- file_path is already absolute from context_state
        if vim.fn.filereadable(file_path) == 1 then
            local file_lines = vim.fn.readfile(file_path)
            local file_content = table.concat(file_lines, "\n")
            local ft = vim.fn.fnamemodify(file_path, ":e") or "text"

            if #file_content > 0 then
                if string.len(file_content) > max_len then
                    file_content = string.sub(file_content, 1, max_len) .. "\n... (truncated)"
                end
                local file_context_text = string.format(
                    "Context: File (%s) content:\n```%s\n%s\n```",
                    file_path,
                    ft,
                    file_content
                )
                table.insert(context_items, { role = "user", text = file_context_text })
            end
        else
            print("Warning: Could not read context file from state: " .. file_path)
            -- Optionally remove it from state if it's no longer readable?
            -- context_state.remove_file(file_path)
        end
    end

    -- TODO: 3. LSP Diagnostics
    -- local diagnostics = vim.diagnostic.get(buf_handle)
    -- Format and add diagnostics...

    -- TODO: 4. Project context (e.g., git status, relevant files)

    return context_items
end

return M 