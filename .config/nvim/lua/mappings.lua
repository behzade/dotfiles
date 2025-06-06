local set = vim.keymap.set

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
-- Other
set("n", "<leader>n", "<cmd>noh<cr>")
set("n", "<leader>s", "<cmd>update<cr>")
set("n", "qq", "<cmd>cclose<cr>")


set("n", "<leader>b", require("oil").open_float)


-- use lower case marks as global
set("n", "gm", [["m".toupper(nr2char(getchar()))]], { expr = true })
set("n", "`", [["`".toupper(nr2char(getchar()))]], { expr = true })
set("n", "'", [["'".toupper(nr2char(getchar()))]], { expr = true })

set("n", "<leader>gq", function() vim.lsp.buf.format({ async = true }) end)

set("n", "<c-f>", "<c-f>zz")
set("n", "<c-b>", "<c-b>zz")
set("n", "<c-d>", "<c-d>zz")
set("n", "<c-u>", "<c-u>zz")

set("i", "<a-bs>", "<esc>cvb", {})

set("n", "<leader>pp", "<cmd>!bunx prettier --write %<cr>")

-- toggleterm
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", count = 5 })

local function _lazygit_toggle()
    lazygit:toggle()
end

set("n", "<c-g>", _lazygit_toggle)
set("t", "<c-g>", _lazygit_toggle)

-- gitsigns
local has_gs, gs = pcall(require, "gitsigns")
if has_gs then
    set("n", "[h", function() gs.nav_hunk('prev') end)
    set("n", "]h", function() gs.nav_hunk('next') end)
    set("n", "<leader>gu", function() gs.reset_hunk() end)
    set("n", "<leader>gd", function() gs.diffthis() end)
end

local has_telescope, telescope_builtins = pcall(require, "telescope.builtin")
if has_telescope then
    set("n", "<leader>ff", telescope_builtins.find_files)
    set("n", "<leader>fs", telescope_builtins.live_grep)
    set("n", "<leader>fg", telescope_builtins.grep_string)
    set("n", "<leader>fr", function() telescope_builtins.resume(require('telescope.themes').get_ivy({})) end)

    set("n", "<leader>gs", telescope_builtins.git_status)
    set("n", "<leader>li", telescope_builtins.lsp_implementations)
    set("n", "<leader>ls", telescope_builtins.lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope_builtins.diagnostics)
    set("n", "gD", telescope_builtins.lsp_references)
end

local has_fzf, fzf = pcall(require, "fzf-lua")
if has_fzf then
    set("n", "<leader>ff", fzf.files)
    set("n", "<leader>fr", fzf.resume)
    set("n", "<leader>fs", fzf.live_grep)
    set("n", "<leader>fg", fzf.grep_cword)


    -- git
    set("n", "<leader>gs", fzf.git_status)
    set("n", "<leader>gb", fzf.git_bcommits)
    set("n", "<leader>gc", fzf.git_commits)
    set("n", "<leader>gt", fzf.git_tags)
    set("n", "<leader>gr", fzf.git_branches)

    -- lsp
    set("n", "<leader>li", fzf.lsp_implementations)
    set("n", "<leader>ls", fzf.lsp_live_workspace_symbols)
    set("n", "<leader>ld", fzf.diagnostics_workspace)
    set("n", "gD", fzf.lsp_references)
    set("n", "<leader>lf", fzf.lsp_finder)
end


local has_dap, dap = pcall(require, "dap")
if has_dap then
    local dapui = require("dapui")
    set("n", "<leader>db", dap.toggle_breakpoint)
    set("n", "<leader>dd", dap.continue)
    set("n", "<leader>dl", dap.step_over)
    set("n", "<leader>dj", dap.step_into)
    set("n", "<leader>dk", dap.step_out)
    set("n", "<leader>dh", dap.step_back)
    set("n", "<leader>dt", dapui.toggle)
end

set("n", "<leader>vf", function()
    vim.cmd([[syntax match ZeroWidthNonJoiner "\u200c" conceal]])
    vim.cmd([[syntax match ZeroWidthNonJoiner "‌" conceal]])
end)

local treesj = require("treesj")
set("n", "<space>m", treesj.toggle)

set("n", "<leader>lm", require("daemon.ui").show)
