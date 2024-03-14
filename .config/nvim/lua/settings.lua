-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local opt = vim.opt -- global/buffer/windows-scoped options
local autocmd = vim.api.nvim_create_autocmd

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = "a"
opt.shell = "fish"
opt.clipboard = "unnamedplus"
opt.swapfile = false  -- disable swap file
opt.wb = false        -- disable writeback
opt.backup = false    -- disable backup
opt.wrap = true       -- soft wrap
opt.showmode = false  -- don't show insert mode etc in the status line
opt.number = true     -- show line number
opt.showmatch = true  -- highlight matching parenthesis
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- orizontal split to the bottom
opt.ignorecase = true -- ignore case letters when search
opt.smartcase = true  -- ignore lowercase for the whole pattern
opt.linebreak = true  -- wrap on word boundary
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240   -- max column for syntax highlight
opt.undofile = true
opt.guifont = "JetBrainsMono Nerd Font:14"
opt.signcolumn = 'yes'
opt.formatexpr = "v:lua.vim.lsp.formatexpr()"
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- highlight on yank
autocmd('TextYankPost', { callback = function() vim.highlight.on_yank({ timeout = 200 }) end, })
-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
autocmd({ "TermOpen" }, {
    pattern = { "*" },
    command = "startinsert",
})

local delete_term_buf = function(event)
    if (vim.fn.len(vim.fn.win_findbuf(event.buf)) > 0) then
        if (event.match ~= "UnceptionEditRequestReceived" and #vim.fn.getbufinfo({ buflisted = 1 })) == 1 then
            vim.cmd("q")
        end
        vim.cmd("silent bdelete! " .. event.buf)
    end
end

autocmd({ "TermClose" }, {
    pattern = { "*" },
    callback = delete_term_buf
})

autocmd({ "User" }, {
    pattern = { "UnceptionEditRequestReceived" },
    callback = delete_term_buf
})

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true -- enable 24-bit RGB colors

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true   -- use spaces instead of tabs
opt.shiftwidth = 4     -- shift 4 spaces when tab
opt.tabstop = 4        -- 1 tab == 4 spaces
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

opt.list = true
vim.opt.listchars = { tab = "⇥ ", leadmultispace = "┊   ", trail = "␣", nbsp = "⍽" }

vim.cmd([[colorscheme default]])
local mode = io.popen("darkman get"):read("*l")
if mode == "light" then
    vim.opt.background = "light"
else
    vim.opt.background = "dark"
end
