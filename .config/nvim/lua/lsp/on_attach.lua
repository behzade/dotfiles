local lsp = vim.lsp
local set = vim.keymap.set
local Diagnostics = require("lsp/diagnostics")
local telescope = require("telescope.builtin")

local on_attach = function()
    set("n", "K", lsp.buf.hover)
    set("n", "gd", lsp.buf.definition)
    set("n", "<leader>bf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>")
    set("v", "<leader>bf", "<cmd>lua vim.lsp.buf.range_format{async=true}<cr>")
    set("n", "<leader>r", lsp.buf.rename)
    set("n", "[d", Diagnostics.prev)
    set("n", "]d", Diagnostics.next)
    set("n", "<leader>fa", lsp.buf.code_action)
    set("n", "<leader>fi", telescope.lsp_implementations)
    set("n", "<leader>fl", telescope.lsp_dynamic_workspace_symbols)
    set("n", "gr", telescope.lsp_references)
    set("n", "<leader>fd", telescope.diagnostics)
end

return on_attach
