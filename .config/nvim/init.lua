require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
       "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup("plugins")
require("modules").setup()
require("mappings")


local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- Add our custom basalt parser
parser_config.basalt = {
  install_info = {
    -- The path to your grammar folder
    url = vim.fn.stdpath("config") .. "/parsers/tree-sitter-basalt", 
    files = {"src/parser.c"},
    -- This is the crucial part:
    -- It tells nvim-treesitter to run `tree-sitter generate` for you
    requires_generate_from_grammar = true, 
  },
  filetype = "bst", -- Associate .bst files with this parser
}

vim.filetype.add({
  extension = {
    bst = "basalt",
  },
})
