local M = {}

-- Try to require plenary's curl module
local pcurl, curl = pcall(require, "plenary.curl")

local api_key = vim.env.GEMINI_API_KEY
local gemini_api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro-exp-03-25:generateContent"

--- Checks if the Gemini API key and plenary curl are available
function M.is_available()
    return api_key ~= nil and api_key ~= "" and pcurl
end

--- Asynchronously gets a response from the Gemini API using plenary.curl
-- @param prompt string The user's input prompt
-- @param context_items table A list of context items, each with {role = "user"|"model", text = "..."}
-- @param callback function A function to call with the result (string response or error message)
function M.request_gemini_response(prompt, context_items, callback)
    if not M.is_available() then
        vim.schedule(function()
            local err_msg = pcurl and "AI: Error - GEMINI_API_KEY environment variable not set."
                           or "AI: Error - plenary.curl could not be required. Is plenary.nvim installed and loaded?"
            callback(err_msg)
        end)
        return
    end

    local url = string.format("%s?key=%s", gemini_api_url, api_key)

    -- Construct the contents list
    local contents = {}
    if context_items then
        for _, item in ipairs(context_items) do
            if item.role and item.text then
                table.insert(contents, {
                    role = item.role,
                    parts = { { text = item.text } },
                })
            end
        end
    end
    -- Add the current user prompt as the last item
    table.insert(contents, {
        role = "user",
        parts = { { text = prompt } },
    })

    local request_body = vim.json.encode({
        contents = contents,
        -- Add generationConfig if needed later (e.g., temperature, max_tokens)
        -- generationConfig = {
        --   temperature = 0.9,
        --   topK = 1,
        --   topP = 1,
        --   maxOutputTokens = 2048,
        --   stopSequences = {}
        -- }
    })

    print("Sending request to Gemini via curl...")
    print("Request Body:", request_body) -- Debug print

    -- Use plenary.curl.post
    curl.post(url, {
        body = request_body,
        headers = {
            ["Content-Type"] = "application/json",
        },
        -- Callback to handle the response
        callback = function(response)
            -- Schedule the processing on the main Neovim thread
            vim.schedule(function()
                print("Received response:", vim.inspect(response)) -- Debug print
                -- Check curl exit code and HTTP status code
                if response.exit ~= 0 or response.status < 200 or response.status >= 300 then
                    local err_body = response.body or "(no response body)"
                    callback(string.format("AI: Error - curl exit: %d, HTTP status: %d - %s",
                                            response.exit or -1,
                                            response.status or -1,
                                            err_body))
                    return
                end

                local success, result = pcall(vim.json.decode, response.body)
                -- Safer parsing logic
                local ai_text = "AI: Error - Could not parse Gemini response structure."
                if success and result and result.candidates and result.candidates[1] and result.candidates[1].content and result.candidates[1].content.parts and result.candidates[1].content.parts[1] and result.candidates[1].content.parts[1].text then
                     ai_text = result.candidates[1].content.parts[1].text
                else
                    print("Failed to parse response:", response.body) -- Debug print
                end

                callback(string.format("AI: %s", ai_text)) -- Add AI prefix
            end)
        end,
        -- Optional: Add error handler for job failures (before HTTP errors)
        on_error = function(err_data)
             vim.schedule(function()
                callback(string.format("AI: Error - curl job failed: %s", err_data.message or vim.inspect(err_data)))
            end)
        end,
    })
end

return M 
