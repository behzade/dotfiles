require("lsp/style")
local has_php, php_opts = pcall(require, "lsp/php")
if has_php then
    local null = require("null-ls")
    null.register({
        php_opts.php_source,
        php_opts.phpcs_source,
        php_opts.phpcbf_source,
        null.builtins.diagnostics.twigcs
    })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require("nvim-lsp-installer").setup()
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
    settings = require("lsp/gopls"),
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
    capabilities = capabilities,
})

lspconfig.phpactor.setup({
    root_dir = php_opts.root_dir,
    capabilities = capabilities,
})
lspconfig.intelephense.setup({
    root_dir = php_opts.root_dir,
    capabilities = capabilities,
})
