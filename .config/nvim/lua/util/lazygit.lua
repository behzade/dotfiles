local M = {}


local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", count = 5 })

function M.lazygit_toggle()
    lazygit:toggle()
end

return M
