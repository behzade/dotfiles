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
set('t', '<esc>', [[<C-\><C-n>]])
set('t', 'jk', [[<C-\><C-n>]])
set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
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
set("n", "<leader>t", "<cmd>SidebarNvimToggle<cr>")
set("n", "<leader>s", "<cmd>update<cr>")
set("n", "qq", "<cmd>cclose<cr>")

set("n", "<leader>ff", telescope_builtins.find_files)
set("n", "<leader>fs", telescope_builtins.live_grep)
set("n", "<leader>fg", telescope_builtins.grep_string)
set("n", "<leader>fb", telescope_extensions.file_browser.file_browser)

set("n", "<leader>p", telescope_extensions.projects.projects)
-- Git
set("n", "<leader>gg", require("lazygit"))
set("n", "<leader>gb", function() gs.toggle_current_line_blame() end)
set("n", "<leader>gu", function() gs.reset_hunk() end)
set("n", "<leader>gd", function() gs.diffthis() end)
set("n", "<leader>gc", telescope_builtins.git_commits)
set("n", "<leader>gs", telescope_builtins.git_status)
set("n", "<leader>gb", telescope_builtins.git_bcommits)


set("n", "<leader>k", require("rtl"))

set("n", "``", require("harpoon.ui").toggle_quick_menu)
set("n", "`1", function() require("harpoon.ui").nav_file(1) end)
set("n", "`2", function() require("harpoon.ui").nav_file(2) end)
set("n", "`3", function() require("harpoon.ui").nav_file(3) end)
set("n", "`4", function() require("harpoon.ui").nav_file(4) end)

set("n", "gm", require("harpoon.mark").add_file)

set({ "n", "t", "v", "i" }, "<c-t>", "<cmd>ToggleTerm<cr>")
