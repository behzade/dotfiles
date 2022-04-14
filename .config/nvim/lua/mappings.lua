vim.g.mapleader = " "
vim.g.maplocalleader = ","
local set = vim.keymap.set
local del = vim.keymap.del
local lsp = vim.lsp
local gs = require('gitsigns')
local fzf = require('fzf-lua')

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

set("n", "K", lsp.buf.hover)
set("n", "gd", lsp.buf.definition)
set("n", "<leader>bf", lsp.buf.formatting)
set("v", "<leader>bf", lsp.buf.range_formatting)
set("n", "<leader>r", lsp.buf.rename)
set("n", "<leader>i", lsp.buf.implementation)

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
-- jump to last open buffer
set("n", "<backspace>", "<c-^>")
-- [] jumps
set("n", "[g", "g;")
set("n", "]g", "g,")
set("n", "[d", Diagnostics.prev)
set("n", "]d", Diagnostics.next)
set("n", "[q", "<cmd>cp<cr>")
set("n", "]q", "<cmd>cn<cr>")
set("n", "[h", function()
	gs.prev_hunk()
end)
set("n", "]h", function()
	gs.next_hunk()
end)
-- Other
set("n", "<leader>n", "<cmd>noh<cr>")
set("n", "<leader>t", "<cmd>SidebarNvimToggle<cr>")
set("n", "<leader>s", "<cmd>update<cr>")
set("n", "qq", "<cmd>cclose<cr>")
-- FZF
set("n", "<leader>ff", fzf.files)
set("n", "<leader>fg", fzf.grep_project)
set("n", "<leader>fs", fzf.grep_cword)
set("n", "<leader>fd", fzf.lsp_document_diagnostics)
set("n", "<leader>fe", fzf.lsp_workspace_diagnostics)
set("n", "<leader>fk", fzf.keymaps)
set("n", "<leader>fl", fzf.lsp_live_workspace_symbols)
set("n", "<leader>fa", fzf.lsp_code_actions)
set("n", "gr", fzf.lsp_references)
set("n", "<leader>gs", fzf.git_status)
