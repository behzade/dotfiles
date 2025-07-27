local M = {}

M.config = {
    root = nil,
}

local state = {
    output_win_id = nil,
    output_bufnr = nil,
    output_chan_id = nil,
}

-- This function is now more robust in how it creates the terminal window.
local function open_output_terminal()
    -- If we have a buffer but its window was closed, handle it.
    if state.output_bufnr and (not state.output_win_id or not vim.api.nvim_win_is_valid(state.output_win_id)) then
        local win_id = vim.fn.bufwinid(state.output_bufnr)
        if win_id ~= -1 then
            state.output_win_id = win_id
        else
            if vim.api.nvim_buf_is_valid(state.output_bufnr) then
                vim.api.nvim_buf_delete(state.output_bufnr, { force = true })
            end
            state.output_bufnr, state.output_win_id, state.output_chan_id = nil, nil, nil
        end
    end

    -- If the buffer/window doesn't exist, create it from scratch.
    if not state.output_bufnr then
        local original_win = vim.api.nvim_get_current_win()
        vim.cmd('rightbelow vsplit | enew')
        state.output_win_id = vim.api.nvim_get_current_win()
        state.output_bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_option(state.output_bufnr, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(state.output_bufnr, 'bufhidden', 'hide')
        vim.api.nvim_buf_set_option(state.output_bufnr, 'swapfile', false)
        vim.api.nvim_buf_set_name(state.output_bufnr, 'Basalt Output')
        vim.api.nvim_win_set_option(state.output_win_id, 'number', false)
        vim.api.nvim_win_set_option(state.output_win_id, 'relativenumber', false)
        vim.api.nvim_win_set_option(state.output_win_id, 'signcolumn', 'no')
        vim.api.nvim_win_set_option(state.output_win_id, 'statuscolumn', '')
        vim.keymap.set({ "n", "t" }, "q", "<cmd>close<cr>", { silent = true, buffer = state.output_bufnr })
        vim.schedule(function() vim.api.nvim_set_current_win(original_win) end)
    end

    -- FIX: Always re-initialize the terminal process to get a clean state.
    state.output_chan_id = vim.api.nvim_open_term(state.output_bufnr, {})
    vim.api.nvim_create_autocmd("TermEnter", {
        buffer = state.output_bufnr,
        once = true,
        command = "stopinsert",
    })
end



local function run_command(cmd_arg, title)
    -- Remember where we started
    local original_win = vim.api.nvim_get_current_win()

    if not M.config.root or vim.fn.isdirectory(M.config.root) == 0 then
        vim.notify(
            "Basalt: Compiler root is not set or is not a valid directory.",
            vim.log.levels.ERROR,
            { title = "Basalt Plugin" }
        )
        return
    end

    -- 1. Ensure the UI (window/buffer) is ready.
    open_output_terminal()

    if not state.output_bufnr or not vim.api.nvim_win_is_valid(state.output_win_id) then
        vim.notify("Basalt: Could not access the output terminal.", vim.log.levels.ERROR)
        return
    end

    -- 2. Explicitly switch TO the terminal window to manage its state directly.
    -- This ensures any following commands (and your autocommands) apply here.
    vim.api.nvim_set_current_win(state.output_win_id)

    -- 3. Now that we are in the correct window, wipe and set up the terminal.
    vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(state.output_bufnr, 0, -1, false, {})
    vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', false)

    -- Prevent Neovim's default `startinsert` and immediately counteract your
    -- custom `startinsert` to force the terminal into normal mode.
    vim.g.terminal_skip_startinsert = 1
    local chan_id = vim.api.nvim_open_term(state.output_bufnr, {})
    vim.g.terminal_skip_startinsert = 0
    vim.cmd.stopinsert()

    -- 4. Schedule the focus to return to the original window.
    vim.schedule(function()
        if vim.api.nvim_win_is_valid(original_win) then
            vim.api.nvim_set_current_win(original_win)
        end
    end)

    -- 5. Run the command (this logic is unchanged).
    local source_code_lines = vim.api.nvim_buf_get_lines(vim.fn.winbufnr(original_win), 0, -1, false)
    local header = title
    vim.fn.setwinvar(state.output_win_id, '&winbar', header .. " ⏳")
    local command_to_run = { 'devbox', 'run', '--', 'cargo', 'run', '--quiet', '--', cmd_arg }

    local job_id = vim.fn.jobstart(command_to_run, {
        cwd = M.config.root,
        stdin = "pipe",
        on_stdout = function(_, data, _)
            if chan_id and data then
                vim.schedule(function() vim.api.nvim_chan_send(chan_id, table.concat(data, "\r\n") .. "\r\n") end)
            end
        end,
        on_stderr = function(_, data, _)
            if chan_id and data then
                vim.schedule(function() vim.api.nvim_chan_send(chan_id, table.concat(data, "\r\n") .. "\r\n") end)
            end
        end,
        on_exit = function(_, code, _)
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(state.output_win_id) then
                    vim.fn.setwinvar(state.output_win_id, '&winbar', (code == 0 and header .. " ✅") or (header .. " ❌"))
                end
            end)
        end,
    })

    if job_id and job_id > 0 then
        vim.fn.chansend(job_id, source_code_lines)
        vim.fn.chanclose(job_id, "stdin")
    else
        vim.notify("Failed to start Basalt command.", vim.log.levels.ERROR, { title = "Basalt Plugin" })
        if vim.api.nvim_win_is_valid(state.output_win_id) then
            vim.fn.setwinvar(state.output_win_id, '&winbar', header .. " 🔥")
        end
    end
end


-- M.setup doesn't need changes, so it's omitted for brevity.
-- Just ensure you return the full module.
function M.setup(opts)
    opts = opts or {}
    M.config = vim.tbl_deep_extend("force", M.config, opts)

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
            local bufnr = args.buf
            for _, cmd_info in ipairs(commands) do
                vim.keymap.set('n', cmd_info.map, function() run_command(cmd_info.arg, cmd_info.title) end, {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                    desc = "Basalt: " .. cmd_info.name,
                })
            end
        end,
    })
end

return M
