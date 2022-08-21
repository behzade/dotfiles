return function()
    local terminal = require('toggleterm.terminal').Terminal
    local lazygit = terminal:new({
        cmd = "lazygit -p " .. vim.fn.getcwd(),
        hidden = true, direction = "float",
        on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<esc>", "<cmd>close<cr>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<c-c>", "<cmd>close<cr>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(term.bufnr, "i", "<c-c>", "<cmd>close<cr>", { noremap = true, silent = true })
        end,
    })
    return lazygit:toggle()
end
