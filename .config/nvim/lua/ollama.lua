local json = vim.fn.json_encode -- alias for encoding payload

local get_file_context = function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return table.concat(lines, "\n")
end

-- Helper function to split text into safe lines (no embedded newlines)
local safe_split = function(text)
    local lines = {}
    for line in text:gmatch("[^\n]+") do
        local clean_line = line:gsub("\n", " ")
        table.insert(lines, clean_line)
    end
    return lines
end

local process_stream_chunk = function(chunk)
    local parts = {}
    -- Each line is expected to be a JSON object.
    for line in chunk:gmatch("[^\n]+") do
        if line ~= "" then
            local ok, data = pcall(vim.fn.json_decode, line)
            if ok and data and data.response then
                table.insert(parts, data.response)
            end
        end
    end
    return table.concat(parts, "")
end

local send_to_model = function(context, prompt, model)
    local payload_table = {
        prompt = "prompt: " .. prompt .. "\ncontext: " .. context,
        model = model,
        system = table.concat({
            "You are a fast, efficient coding companion running locally.",
            "Avoid extra computation and provide answers that are as concise and correct as possible.",
            "Your role is to help with menial coding tasks — think of yourself as a junior developer.",
            "If the prompt is empty, deduce the likely desired action from the context.",
            "Do not provide extensive commentary or design solutions.",
            "Focus solely on producing succinct, correct code that the user can readily accept or modify."
        }, "\n"),
        stream = true,
    }
    local payload = json(payload_table)

    -- Open a new vertical split and create a scratch buffer.
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    -- Set markdown filetype.
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    -- Write initial "Processing..." message.
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Processing..." })

    print("Payload: " .. payload)

    local result_accumulated = ""

    -- Build curl command as a list of arguments.
    local args = {
        "curl",
        "-s", -- silent mode: suppress progress meter
        "-S", -- but still show errors
        "-X", "POST",
        "http://localhost:11434/api/generate",
        "-H", "Content-Type: application/json",
        "--data", payload,
        "--no-buffer",
    }

    local job_id = vim.fn.jobstart(args, {
        stdout_buffered = false, -- stream data immediately
        on_stdout = function(_, data, _)
            if data then
                local chunk = table.concat(data, "\n")
                local chunk_result = process_stream_chunk(chunk)
                if chunk_result and chunk_result ~= "" then
                    result_accumulated = result_accumulated .. chunk_result
                    local lines = safe_split(result_accumulated)
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(buf) then
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                        end
                    end)
                end
            end
        end,
        on_stderr = function(_, data, _)
            -- Only update the buffer if stderr contains meaningful content.
            local stderr_output = table.concat(data, "\n")
            if stderr_output:match("%S") then -- if there's any non-space character
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_buf_set_lines(
                            buf, 0, -1, false,
                            safe_split("stderr: " .. stderr_output)
                        )
                    end
                end)
            end
        end,
        on_exit = function(_, exit_code, _)
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    if exit_code ~= 0 then
                        vim.api.nvim_buf_set_lines(
                            buf, 0, -1, false,
                            safe_split("Error: curl exited with code " .. exit_code)
                        )
                    end
                end
            end)
        end,
    })

    if job_id <= 0 then
        print("Failed to start curl job!")
    end
end

local send_file_with_prompt = function()
    local prompt = vim.fn.input("Prompt: ")
    send_to_model(get_file_context(), prompt, "codellama")
end

vim.keymap.set("n", "<leader>gl", send_file_with_prompt, {
    noremap = true,
    silent = true,
})
