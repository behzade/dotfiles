local M        = {}

local lsp      = vim.lsp
M.on_attach    = function(client, bufnr)
    local set = vim.keymap.set

    local telescope = require("telescope.builtin")
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

    set("n", "K", lsp.buf.hover)
    set("n", "gd", gd)
    set("n", "gD", telescope.lsp_references)
    set("n", "[d", prev)
    set("n", "]d", next)
    set("n", "<leader>lr", lsp.buf.rename)
    set("n", "<leader>la", lsp.buf.code_action)
    set("n", "<leader>ll", lsp.codelens.run)
    set("n", "<leader>li", telescope.lsp_implementations)
    set("n", "<leader>ls", telescope.lsp_dynamic_workspace_symbols)
    set("n", "<leader>ld", telescope.diagnostics)
    set("n", "<C-LeftMouse>", gd)

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    if client.name == "yamlls" then
        client.resolved_capabilities = {
            document_formatting = true
        }
    end
end

M.capabilities = function()
    local capabilities                                                 = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    lsp.handlers["textDocument/hover"]                                 = lsp.with(lsp.handlers.hover,
        { border = "single", })
    lsp.handlers["textDocument/signatureHelp"]                         = lsp.with(lsp.handlers.signature_help,
        { border = "single",
        })
    lsp.handlers["textDocument/previewLocation"]                       = lsp.with(lsp.handlers.preview_location,
        { border = "single",
        })
    return capabilities
end

return M
