-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
--local map = vim.api.nvim_set_keymap  -- set global keymap
local cmd = vim.cmd -- execute Vim commands
local exec = vim.api.nvim_exec -- execute Vimscript
local g = vim.g -- global variables
local opt = vim.opt -- global/buffer/windows-scoped options

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
opt.guifont = "JetBrainsMono Nerd Font:h10.8"
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
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true -- enable 24-bit RGB colors
cmd([[
augroup MyColors
    autocmd!
    autocmd ColorScheme * highlight FloatermBorder guifg=orange
                      \ | highlight FloatBorder guifg=orange
                      \ | highlight NormalFloat guibg=white
augroup END
    ]])

cmd([[colorscheme github_light]])
opt.background = "light"

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
-- disable builtins plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- disable nvim intro
opt.shortmess:append("sI")

-----------------------------------------------------------
-- Fold
-----------------------------------------------------------

opt.foldmethod = "indent"
opt.fillchars = "fold: "
opt.foldnestmax = 2
opt.foldminlines = 3

cmd [[highlight Folded guibg=#e9f0f0]]
