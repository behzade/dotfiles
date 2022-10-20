local lsp = vim.lsp
local set = vim.keymap.set
local Diagnostics = require("lsp/diagnostics")
local telescope = require("telescope.builtin")
local navic = require("nvim-navic")

local opts = {
    fname_width = 90,
    cwd = string.sub(vim.fn.getcwd(), 0, string.find(vim.fn.getcwd(), "/[^/]*$")),
}

local lsp_references = function() telescope.lsp_references(opts) end
local lsp_implementations = function() telescope.lsp_implementations(opts) end
local lsp_dynamic_workspace_symbols = function() telescope.lsp_dynamic_workspace_symbols(opts) end

local formatter = function()
    vim.lsp.buf.format({ async = true })
end


local on_attach = function(client, bufnr)
    set("n", "K", lsp.buf.hover)
    set("n", "gd", lsp.buf.definition)
    set("n", "gD", lsp_references)
    set("n", "[d", Diagnostics.prev)
    set("n", "]d", Diagnostics.next)
    set("n", "<leader>lf", formatter)
    set("v", "<leader>lf", formatter)
    set("n", "<leader>lr", lsp.buf.rename)
    set("n", "<leader>la", lsp.buf.code_action)
    set("n", "<leader>li", lsp_implementations)
    set("n", "<leader>ls", lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope.diagnostics)

    navic.attach(client, bufnr)
end

return on_attach
