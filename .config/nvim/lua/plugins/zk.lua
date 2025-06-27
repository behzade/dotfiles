-- Action to open a note (receives a single note object).
local function open_note_action(note)
    if note and note.absPath then
        vim.cmd("edit " .. note.absPath)
    end
end

-- Action to insert a Markdown link (receives a single note object).
-- It uses the note's title and its relative path.
local function insert_link_action(note)
    if note and note.title and note.path then
        local markdown_link = string.format("[%s](%s)", note.title, note.path)
        -- Insert the link at the cursor position
        vim.api.nvim_put({ markdown_link }, "c", false, true)
    end
end

-- Core helper: picks a tag, then a note, then executes a final action.
local function pick_note_by_tag(action_on_note)
    require("zk").pick_tags(nil, nil, function(tags)
        if tags and #tags > 0 then
            local tag_filter = { tags = { tags[1].name } }
            require("zk").pick_notes(tag_filter, nil, function(notes)
                if notes and #notes > 0 then
                    -- Pass the selected note to the final action function.
                    action_on_note(notes[1])
                end
            end)
        end
    end)
end

-- This helper remains for the simple note picker (<leader>kf)
local function open_first_note_from_list(notes)
    if notes and #notes > 0 then
        open_note_action(notes[1])
    end
end

local function get_visual_selection()
    local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
    if start_row == 0 or end_row == 0 then return "" end
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    if #lines == 0 then return "" end

    if #lines == 1 then
        return string.sub(lines[1], start_col, end_col)
    else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
        return table.concat(lines, "\n")
    end
end

return {
    "zk-org/zk-nvim",
    config = function()
        require("zk").setup()
    end,
    keys = {
        -- No changes to creating or finding notes directly
        {
            "<leader>kn",
            function()
                vim.ui.input({ prompt = "Note title: " }, function(title)
                    if title and #title > 0 then
                        require("zk").new({ title = title })
                    end
                end)
            end,
            desc = "[K]nowledge [N]ew Note",
        },
        {
            "<leader>kf",
            function()
                require("zk").pick_notes(nil, nil, open_first_note_from_list)
            end,
            desc = "[K]nowledge [F]ind Note",
        },

        {
            "<leader>kt",
            function()
                pick_note_by_tag(open_note_action)
            end,
            desc = "[K]nowledge find by [T]ag",
        },

        {
            "<leader>kl",
            function()
                pick_note_by_tag(insert_link_action)
            end,
            desc = "[K]nowledge create [L]ink",
        },
        {
            "<A-l>", -- Alt+l to create a link from insert mode
            function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                pick_note_by_tag(insert_link_action)
            end,
            mode = "i",
            desc = "Create Link from Note",
        },

        -- VISUAL MODE BINDINGS --
        {
            "<leader>kn",
            function()
                local selection = get_visual_selection()
                if not (selection and #selection > 0) then return end

                -- Check if the selection is multiline
                if string.find(selection, "\n") then
                    -- MULTILINE: Use as body, prompt for title
                    vim.ui.input({ prompt = "Note title: " }, function(title)
                        if title and #title > 0 then
                            require("zk").new({
                                title = title,
                                content = selection,
                            })
                        end
                    end)
                else
                    -- SINGLE LINE: Use as title
                    require("zk").new({ title = vim.trim(selection) })
                end
            end,
            mode = "v",
            desc = "[K]nowledge [N]ew from selection (smart)",
        },
    },
}
