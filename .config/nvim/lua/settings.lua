-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local opt = vim.opt -- global/buffer/windows-scoped options
local g = vim.g
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
opt.guifont = "JetBrainsMono Nerd Font:16"
opt.signcolumn = 'yes'
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.termbidi = true
g.mapleader = " "
g.maplocalleader = ","
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.winborder = 'rounded'

autocmd({ "TermOpen" }, {
    pattern = { "*" },
    command = "startinsert",
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

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("uv_python_ft_detect", { clear = true }),
  pattern = "*",
  callback = function(args)
    -- Ensure the buffer is valid and has at least one line
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.api.nvim_buf_line_count(args.buf) < 1 then
      return
    end

    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
    local shebang = "#!/usr/bin/env -S uv run --script"

    -- Use string.find with `plain = true` for a literal search.
    -- The check `== 1` ensures the shebang is at the very start of the line.
    if first_line:find(shebang, 1, true) == 1 then
      vim.bo[args.buf].filetype = "python"
    end
  end,
})
