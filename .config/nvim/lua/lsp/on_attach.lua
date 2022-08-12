local lsp = vim.lsp
local set = vim.keymap.set
local Diagnostics = require("lsp/diagnostics")
local telescope = require("telescope.builtin")
local navic = require("nvim-navic")

local on_attach = function(client, bufnr)
    set("n", "K", lsp.buf.hover)
    set("n", "gd", lsp.buf.definition)
    set("n", "gD", telescope.lsp_references)
    set("n", "[d", Diagnostics.prev)
    set("n", "]d", Diagnostics.next)
    set("n", "<leader>lf", vim.lsp.buf.formatting)
    set("v", "<leader>lf", vim.lsp.buf.range_formatting)
    set("n", "<leader>lr", lsp.buf.rename)
    set("n", "<leader>la", lsp.buf.code_action)
    set("n", "<leader>li", telescope.lsp_implementations)
    set("n", "<leader>ls", telescope.lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope.diagnostics)

    navic.attach(client, bufnr)
end

return on_attach
