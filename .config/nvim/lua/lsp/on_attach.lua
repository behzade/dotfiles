local lsp = vim.lsp
local set = vim.keymap.set
local diagnostics = require("lsp/diagnostics")
local telescope = require("telescope.builtin")
local navic = require("nvim-navic")

local opts = {
    fname_width = 90,
}

local lsp_references = function() telescope.lsp_references(opts) end
local lsp_implementations = function() telescope.lsp_implementations(opts) end
local lsp_dynamic_workspace_symbols = function() telescope.lsp_dynamic_workspace_symbols(opts) end

local function on_list(options)
    vim.fn.setqflist({}, ' ', options)
    vim.api.nvim_command('silent cfirst')
end

local on_attach = function(client, bufnr)
    set("n", "K", lsp.buf.hover)
    set("n", "gd", function() lsp.buf.definition({ reuse_win = true, on_list = on_list }) end)
    set("n", "gD", lsp_references)
    set("n", "[d", diagnostics.prev)
    set("n", "]d", diagnostics.next)
    set("n", "<leader>lr", lsp.buf.rename)
    set("n", "<leader>la", lsp.buf.code_action)
    set("n", "<leader>ll", lsp.codelens.run)
    set("n", "<leader>li", lsp_implementations)
    set("n", "<leader>ls", lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope.diagnostics)

    navic.attach(client, bufnr)
end

return on_attach
