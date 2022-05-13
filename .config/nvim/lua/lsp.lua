require("lsp/style")
local has_php, php_opts = pcall(require, "lsp/php")
local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
local on_attach = require('lsp/on_attach')

require("nvim-lsp-installer").setup({
    automatic_installation = true
})
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
    settings = require("lsp/gopls"),
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    },
    on_attach = on_attach,
    capabilities = capabilities,
})

require("null-ls").setup({
    defaults = {
        on_attach = on_attach,
        diagnostics_format = "[#{c}] #{m} (#{s})",
        fallback_severity = vim.diagnostic.severity.WARNING,
    }
})

if has_php then
    local null = require("null-ls")
    null.register({
        php_opts.php_source,
        php_opts.phpcs_source,
        php_opts.phpcbf_source,
        null.builtins.diagnostics.twigcs
    })
    lspconfig.phpactor.setup({
        root_dir = php_opts.root_dir,
        capabilities = capabilities,
        on_attach = on_attach,
    })
    lspconfig.intelephense.setup({
        root_dir = php_opts.root_dir,
        capabilities = capabilities,
        on_attach = on_attach,
    })
end
