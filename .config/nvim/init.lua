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

parser_config.basalt = {
  install_info = {
    url = vim.fn.stdpath("config") .. "/parsers/tree-sitter-basalt", 
    files = {"src/parser.c"},
    requires_generate_from_grammar = true, 
  },
  filetype = "bst",
}

vim.filetype.add({
  extension = {
    bst = "basalt",
  },
})
