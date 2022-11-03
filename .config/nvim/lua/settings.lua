-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
--local map = vim.api.nvim_set_keymap  -- set global keymap
local exec = vim.api.nvim_exec -- execute Vimscript
local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options
local autocmd = vim.api.nvim_create_autocmd

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a"
opt.shell = "fish"
opt.clipboard = "unnamedplus"
opt.swapfile = false -- disable swap file
opt.wb = false -- disable writeback
opt.backup = false -- disable backup
opt.wrap = true -- soft wrap
opt.showmode = false -- don't show insert mode etc in the status line
opt.number = true -- show line number
opt.showmatch = true -- highlight matching parenthesis
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- orizontal split to the bottom
opt.ignorecase = true -- ignore case letters when search
opt.smartcase = true -- ignore lowercase for the whole pattern
opt.linebreak = true -- wrap on word boundary
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240 -- max column for syntax highlight
opt.relativenumber = true
opt.undofile = true
g.tex_flavor = "context" -- use ConTeXt for tex files by default
opt.guifont = "JetBrainsMono Nerd Font:13"
opt.signcolumn = 'yes'

-- highlight on yank
exec(
    [[
      augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
      augroup end
    ]],
    false
)

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
autocmd({ "TermOpen" }, {
    pattern = { "*" },
    command = "startinsert",
})

local delete_term_buf = function (event)
    if (vim.fn.len(vim.fn.win_findbuf(event['buf'])) > 0) then
        vim.cmd("bdelete " .. event['buf'])
        vim.cmd("stopinsert")
    end
end

autocmd({ "TermClose"}, {
    pattern = {"*"},
    callback = delete_term_buf
})

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true -- enable 24-bit RGB colors

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 4 -- shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- autoindent new lines

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Fold
-----------------------------------------------------------

opt.foldmethod = "indent"
opt.fillchars = "fold: "
opt.foldnestmax = 2
opt.foldminlines = 3

-- File browser
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
