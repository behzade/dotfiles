vim.g.mapleader = " "
vim.g.maplocalleader = ","
local set = vim.keymap.set
local gs = require("gitsigns")
local telescope = require("telescope.builtin")

-- insert mode
set("i", "jk", "<esc>")

-- window navigation
set("n", "<c-k>", "<cmd>wincmd k<cr>")
set("n", "<c-j>", "<cmd>wincmd j<cr>")
set("n", "<c-l>", "<cmd>wincmd l<cr>")
set("n", "<c-h>", "<cmd>wincmd h<cr>")
-- better line movement in wrapped text
set("n", "j", "gj")
set("n", "k", "gk")
-- better search
set("n", "/", "/\\v")
set("v", "//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

-- delete keys no longer fill up the registers, cut functionality moved to m key
set("n", "gm", "m")
set("n", "mm", "dd")
set("v", "p", '"_dP')
set({ "n", "v" }, "m", "d")
set({ "n", "v" }, "M", "D")
set({ "n", "v" }, "d", '"_d')
set({ "n", "v" }, "D", '"_D')
set({ "n", "v" }, "x", '"_x')
set({ "n", "v" }, "X", '"_X')
set({ "n", "v" }, "c", '"_c')
set({ "n", "v" }, "C", '"_C')

set("n", "0", function()
    return vim.fn.getline('.')
        :sub(0, vim.fn.col('.') - 1)
        :match("^%s+$") and "0" or "^"
end, { expr = true })

-- jump to last open buffer
set("n", "<backspace>", "<c-^>")
-- [] jumps
set("n", "[g", "g;")
set("n", "]g", "g,")
set("n", "[q", "<cmd>cp<cr>")
set("n", "]q", "<cmd>cn<cr>")
set("n", "[h", function() gs.prev_hunk() end)
set("n", "]h", function() gs.next_hunk() end)
-- Other
set("n", "<leader>n", "<cmd>noh<cr>")
set("n", "<leader>t", "<cmd>SidebarNvimToggle<cr>")
set("n", "<leader>s", "<cmd>update<cr>")
set("n", "qq", "<cmd>cclose<cr>")
set("n", "<leader>fk", telescope.keymaps)
-- Files
set("n", "<leader>ff", telescope.find_files)
-- Text Search
set("n", "<leader>fg", telescope.live_grep)
set("n", "<leader>fs", telescope.grep_string)

set("n", "<leader>fp", "<cmd>Telescope projects<cr>")
-- Git
set("n", "<leader>gs", telescope.git_status)
set("n", "<leader>gb", function() gs.toggle_current_line_blame() end)
set("n", "<leader>gu", function() gs.reset_hunk() end)
set("n", "<leader>gd", function() gs.diffthis() end)
