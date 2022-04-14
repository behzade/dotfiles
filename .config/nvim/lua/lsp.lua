require("lsp/diagnostics")

local has_php, php_opts = pcall(require,"lsp/php")
if has_php then
    local null = require("null-ls")
    null.register({
        php_opts.php_source,
        php_opts.phpcs_source,
        php_opts.phpcbf_source,
        null.builtins.diagnostics.twigcs
        -- php_opts.phpstan_source,
    })
end

local lsp_installer = require("nvim-lsp-installer")
local lsp = vim.lsp

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
 border = "single",
})
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
 border = "single",
})
lsp.handlers["textDocument/previewLocation"] = lsp.with(lsp.handlers.preview_location, {
 border = "single",
})

lsp_installer.on_server_ready(function(server)
    local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
    local opts = { capabilities = capabilities}

    if server.name == "gopls" then
        opts.settings = require("lsp/gopls")
    end
    if server.name == "sumneko_lua" then
        opts.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
    end
    if server.name == "phpactor" or server.name == "intelephense" then
        opts.root_dir = php_opts.root_dir
        opts.indexer = php_opts.indexer
    end
    server:setup(opts)
end)
