local function get_inner_quote()
    vim.fn.setreg('v', '')
    vim.cmd([[noau normal! "vyi" ]])
    local result = vim.fn.getreg('v')
    if result == "" then
        vim.cmd([[noau normal! "vyi']])
    end
    if result == "" then
        vim.cmd([[noau normal! "vyit]])
    end
    return vim.fn.getreg('v')
end

local function notify ()
    local text = get_inner_quote()
    os.execute("notify-send title '" .. text .. "'")
end

return notify
