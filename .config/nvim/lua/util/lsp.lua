local M = {}

local lsp = vim.lsp
M.on_attach = function(client, bufnr)
    -- A buffer-local variant of vim.keymap.set is preferable in on_attach
    local set = function(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    local navic = require("nvim-navic")

    local function on_list(options)
        vim.fn.setqflist({}, ' ', options)
        vim.api.nvim_command('silent cfirst')
    end

    local diagnostic = vim.diagnostic
    local diagnostic_opts = { float = { border = "single" } }

    local next = function() diagnostic.goto_next(diagnostic_opts) end
    local prev = function() diagnostic.goto_prev(diagnostic_opts) end

    local gd = function() lsp.buf.definition({ reuse_win = true, on_list = on_list }) end

    -- Add descriptions to the keymap options table
    set("n", "K", lsp.buf.hover, { desc = "Hover Documentation" })
    set("n", "gd", gd, { desc = "Go to Definition" })
    set("n", "[d", prev, { desc = "Previous Diagnostic" })
    set("n", "]d", next, { desc = "Next Diagnostic" })
    set("n", "<leader>lr", lsp.buf.rename, { desc = "[L]SP [R]ename" })
    set("n", "<leader>la", lsp.buf.code_action, { desc = "[L]SP Code [A]ction" })
    set("n", "<leader>ll", lsp.codelens.run, { desc = "[L]SP Code[L]ens" })
    set("n", "<C-LeftMouse>", gd, { desc = "Go to Definition" })

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

M.capabilities = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    return capabilities
end

return M
