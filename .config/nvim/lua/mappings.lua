local set = vim.keymap.set

-- insert mode
set("i", "jk", "<esc>", { desc = "Exit Insert Mode" })

-- window navigation
set("n", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Window Up" })
set("n", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Window Down" })
set("n", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Window Right" })
set("n", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Window Left" })

-- jump to last open buffer
set("n", "<backspace>", "<c-^>", { desc = "Last Buffer" })

set("n", "/", "/\\v")
set("v", "//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

-- [] jumps
set("n", "[g", "g;", { desc = "Previous Change" })
set("n", "]g", "g,", { desc = "Next Change" })
set("n", "[q", "<cmd>cp<cr>", { desc = "Previous Quickfix" })
set("n", "]q", "<cmd>cn<cr>", { desc = "Next Quickfix" })

set("n", "<leader>s", "<cmd>update<cr>", { desc = "[S]ave File" })

-- Other
set("n", "<leader>n", "<cmd>noh<cr>", { desc = "[N]o Highlight" })
set("n", "qq", "<cmd>cclose<cr>", { desc = "Close Quickfix" })

set("i", "<a-bs>", "<esc>cvb", { desc = "Delete Word Backwards" })

set("n", "<leader>lm", require("daemon.ui").show, { desc = "[L]SP [M]ason Daemon" })

set("n", "0", function()
    return vim.fn.getline('.')
        :sub(0, vim.fn.col('.') - 1)
        :match("^%s+$") and "0" or "^"
end, { expr = true })

-- use lower case marks as global
set("n", "gm", [["m".toupper(nr2char(getchar()))]], { expr = true })
set("n", "`", [["`".toupper(nr2char(getchar()))]], { expr = true })
set("n", "'", [["'".toupper(nr2char(getchar()))]], { expr = true })
