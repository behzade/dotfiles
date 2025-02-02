local curl = require("plenary.curl")

local get_file_context = function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return table.concat(lines, "\n")
end

local process_stream = function(body)
    local parts = {}
    for line in body:gmatch("[^\n]+") do
        local ok, data = pcall(vim.json.decode, line)
        if ok and data and data.response then
            table.insert(parts, data.response)
        end
    end
    return table.concat(parts, "")
end

local send_to_model = function(context, prompt, model)
    local payload = vim.json.encode({
        prompt = vim.json.encode({
            prompt = prompt,
            file_context = context,
        }),
        model = model,
        system = "you are a coding assistant, you're trying to response with as little as tokens as possible to preserve energy",
        stream = true,
    })

    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    print(payload)
    curl.post({
        url = "http://localhost:11434/api/generate",
        body = payload,
        headers = { ["Content-Type"] = "application/json" },
        callback = function(response)
            vim.schedule(function()
                if response.status == 200 then
                    local result = process_stream(response.body)
                    if result ~= "" then
                        local lines = {}
                        for line in result:gmatch("[^\n]+") do
                            table.insert(lines, line)
                        end
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                    else
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error: No valid response data" })
                    end
                else
                    vim.api.nvim_buf_set_lines(
                        buf,
                        0,
                        -1,
                        false,
                        {
                            "Error: " .. response.status,
                            "Body: " .. response.body,
                        }
                    )
                end
            end)
        end,
    })
end

local send_file_with_prompt = function()
    local prompt = vim.fn.input("Enter prompt: ")
    if prompt == "" then
        print("Error: Empty prompt!")
        return
    end
    local context = get_file_context()
    send_to_model(context, prompt, "phi3")
end

vim.keymap.set("n", "<leader>gl", send_file_with_prompt, { noremap = true, silent = true })
