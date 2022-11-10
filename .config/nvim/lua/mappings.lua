vim.g.mapleader = " "
vim.g.maplocalleader = ","
local set = vim.keymap.set
local gs = require("gitsigns")
local telescope_builtins = require("telescope.builtin")
local telescope_extensions = require("telescope").extensions

-- insert mode
set("i", "jk", "<esc>")

-- window navigation
set("n", "<c-k>", "<cmd>wincmd k<cr>")
set("n", "<c-j>", "<cmd>wincmd j<cr>")
set("n", "<c-l>", "<cmd>wincmd l<cr>")
set("n", "<c-h>", "<cmd>wincmd h<cr>")
set('t', '<c-h>', "<cmd>wincmd h<cR>")
set('t', '<c-j>', "<cmd>wincmd j<cR>")
set('t', '<c-k>', "<cmd>wincmd k<cR>")
set('t', '<c-l>', "<cmd>wincmd l<cR>")
-- better line movement in wrapped text
set("n", "j", "gj")
set("n", "k", "gk")
-- better search
set("n", "/", "/\\v")
set("v", "//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

-- delete keys no longer fill up the registers, cut functionality moved to m key
set("n", "mm", "dd")
set("v", "p", [[<Plug>ReplaceWithRegisterVisual]])
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
set("n", "<leader>t", "<cmd>term<cr>")
set("n", "<leader>s", "<cmd>update<cr>")
set("n", "qq", "<cmd>cclose<cr>")

set("n", "<leader>ff", telescope_builtins.find_files)
set("n", "<leader>fs", telescope_builtins.live_grep)
set("n", "<leader>fg", telescope_builtins.grep_string)

set("n", "<leader>p", telescope_extensions.projects.projects)
-- Git
set("n", "<leader>u", function() gs.reset_hunk() end)

set("n", "<leader>gd", function() gs.diffthis() end)
set("n", "<leader>gg", "<cmd>term lazygit<cr>")
set("n", "<leader>gb", "<cmd>term lazygit -f %<cr>")

set("n", "<leader>b", "<cmd>term lf<cr>")


set("n", "<leader>k", require("rtl"))

-- use lower case marks as global
set("n", "gm", [["m".toupper(nr2char(getchar()))]], { expr = true })
set("n", "`", [["`".toupper(nr2char(getchar()))]], { expr = true })
set("n", "'", [["'".toupper(nr2char(getchar()))]], { expr = true })

set("n", "<leader>\\", Html)
