local diagnostic = vim.diagnostic
local opts = { float = { border = "single" } }

return {
    next = function() diagnostic.goto_next(opts) end,
    prev = function() diagnostic.goto_prev(opts) end,
}
