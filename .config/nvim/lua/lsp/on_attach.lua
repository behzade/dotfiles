local lsp = vim.lsp
local set = vim.keymap.set
local Diagnostics = require("lsp/diagnostics")
local telescope = require("telescope.builtin")
local navic = require("nvim-navic")

local on_attach = function(client, bufnr)
    set("n", "K", lsp.buf.hover)
    set("n", "gd", lsp.buf.definition)
    set("n", "<leader>bf", vim.lsp.buf.formatting)
    set("v", "<leader>bf", vim.lsp.buf.range_formatting)
    set("n", "<leader>r", lsp.buf.rename)
    set("n", "[d", Diagnostics.prev)
    set("n", "]d", Diagnostics.next)
    set("n", "<leader>fa", lsp.buf.code_action)
    set("n", "<leader>fi", telescope.lsp_implementations)
    set("n", "<leader>fl", telescope.lsp_dynamic_workspace_symbols)
    set("n", "<leader>fr", telescope.lsp_references)
    set("n", "<leader>fd", telescope.diagnostics)

    navic.attach(client, bufnr)
end

return on_attach
