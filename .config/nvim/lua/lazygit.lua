return function()
    local terminal = require('toggleterm.terminal').Terminal
    local lazygit = terminal:new({
        cmd = "lazygit -p " .. vim.fn.getcwd(),
        hidden = true, direction = "float"
    })
    return lazygit:toggle()
end
