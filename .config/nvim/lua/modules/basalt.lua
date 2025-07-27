local M = {}

M.config = {
    root = nil,
}

local state = {
    output_win_id = nil,
    output_bufnr = nil,
}

local function open_output_window()
    if not state.output_bufnr or not vim.api.nvim_buf_is_valid(state.output_bufnr) then
        vim.notify("Basalt output buffer is not available.", vim.log.levels.ERROR)
        return
    end

    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        if vim.api.nvim_win_get_buf(win) == state.output_bufnr then
            state.output_win_id = win
            return
        end
    end

    local current_win = vim.api.nvim_get_current_win()

    vim.cmd('rightbelow vsplit')
    local new_win = vim.api.nvim_get_current_win()
    state.output_win_id = new_win

    vim.api.nvim_win_set_buf(new_win, state.output_bufnr)
    vim.api.nvim_set_current_win(current_win)
end

local function run_command(cmd_arg, title)
    if not M.config.root or vim.fn.isdirectory(M.config.root) == 0 then
        vim.notify(
            "Basalt: Compiler root is not set or is not a valid directory.",
            vim.log.levels.ERROR,
            { title = "Basalt Plugin" }
        )
        return
    end

    open_output_window()

    local current_bufnr = vim.api.nvim_get_current_buf()
    local source_code_lines = vim.api.nvim_buf_get_lines(current_bufnr, 0, -1, false)

    vim.api.nvim_buf_set_lines(state.output_bufnr, 0, -1, false, {})
    local header = title
    vim.fn.setwinvar(state.output_win_id, '&winbar', header)

    local command_to_run = { 'devbox', 'run', '--', 'cargo', 'run', '--quiet', '--', cmd_arg }
    local output_lines = {}

    local job_id = vim.fn.jobstart(command_to_run, {
        cwd = M.config.root,
        stdin = "pipe", -- IMPORTANT: We need to connect to the process's stdin.
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then table.insert(output_lines, line) end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then table.insert(output_lines, line) end
                end
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                -- Filter out devbox/rustup info messages.
                local filtered_lines = {}
                for _, line in ipairs(output_lines) do
                    if not (vim.startswith(line, "info:") or vim.startswith(line, "Info:")) or vim.startswith(line, "  nightly") then
                        table.insert(filtered_lines, line)
                    end
                end

                -- Write the filtered output to the buffer.
                if #filtered_lines > 0 then
                    vim.api.nvim_buf_set_lines(state.output_bufnr, 0, -1, false, filtered_lines)
                end

                if code == 0 then
                    vim.fn.setwinvar(state.output_win_id, '&winbar', header .. " ✅")
                else
                    vim.fn.setwinvar(state.output_win_id, '&winbar', header .. " ❌")
                end
            end)
        end,
    })

    if job_id and job_id > 0 then
        -- vim.fn.chansend can take a list of strings directly.
        vim.fn.chansend(job_id, source_code_lines)
        -- IMPORTANT: Close the stdin channel to signal EOF to the compiler.
        vim.fn.chanclose(job_id, "stdin")
    else
        vim.notify("Failed to start Basalt command.", vim.log.levels.ERROR, { title = "Basalt Plugin" })
    end
end

function M.setup(opts)
    opts = opts or {}
    M.config = vim.tbl_deep_extend("force", M.config, opts)

    if not state.output_bufnr or not vim.api.nvim_buf_is_valid(state.output_bufnr) then
        state.output_bufnr = vim.api.nvim_create_buf(false, true) -- (listed, scratch)
        vim.api.nvim_buf_set_option(state.output_bufnr, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(state.output_bufnr, 'bufhidden', 'hide')
        vim.api.nvim_buf_set_option(state.output_bufnr, 'swapfile', false)
        vim.api.nvim_buf_set_name(state.output_bufnr, 'Basalt Output')
    end

    local commands = {
        { name = "Parse", arg = "parse", map = "<leader>cp", title = "Parse" },
        { name = "HIR",   arg = "hir",   map = "<leader>ch", title = "High-Level IR" },
        { name = "MIR",   arg = "mir",   map = "<leader>cm", title = "Mid-Level IR" },
        { name = "Build", arg = "build", map = "<leader>cb", title = "Build" },
    }

    for _, cmd_info in ipairs(commands) do
        vim.api.nvim_create_user_command(
            "Basalt" .. cmd_info.name,
            function() run_command(cmd_info.arg, cmd_info.title) end,
            { desc = "Run Basalt '" .. cmd_info.arg .. "'" }
        )
    end

    local group = vim.api.nvim_create_augroup("BasaltFileTypeKeymaps", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "basalt",
        group = group,
        desc = "Setup Basalt keymaps for the current buffer.",
        callback = function(args)
            -- This callback creates buffer-local keymaps.
            local bufnr = args.buf
            for _, cmd_info in ipairs(commands) do
                vim.keymap.set('n', cmd_info.map, function() run_command(cmd_info.arg, cmd_info.title) end, {
                    noremap = true,
                    silent = true,
                    buffer = bufnr, -- This is correct and makes the keymap buffer-local
                    desc = "Basalt: " .. cmd_info.name,
                })
            end
        end,
    })
end

return M
