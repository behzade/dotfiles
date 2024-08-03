local set = vim.keymap.set
local telescope = require("telescope.builtin")
local navic = require("nvim-navic")
local lsp = vim.lsp

local function on_list(options)
    vim.fn.setqflist({}, ' ', options)
    vim.api.nvim_command('silent cfirst')
end

local diagnostic = vim.diagnostic
local diagnostic_opts = { float = { border = "single" } }

local next = function() diagnostic.goto_next(diagnostic_opts) end
local prev = function() diagnostic.goto_prev(diagnostic_opts) end

local on_attach = function(client, bufnr)
    set("n", "K", lsp.buf.hover)
    set("n", "gd", function() lsp.buf.definition({ reuse_win = true, on_list = on_list }) end)
    set("n", "gD", telescope.lsp_references)
    set("n", "[d", prev)
    set("n", "]d", next)
    set("n", "<leader>lr", lsp.buf.rename)
    set("n", "<leader>la", lsp.buf.code_action)
    set("n", "<leader>ll", lsp.codelens.run)
    set("n", "<leader>li", telescope.lsp_implementations)
    set("n", "<leader>ls", telescope.lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope.diagnostics)

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

return {
    on_attach = on_attach,
}
