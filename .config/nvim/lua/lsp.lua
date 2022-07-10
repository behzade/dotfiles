require("lsp/style")
require("nvim-lsp-installer").setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(
    capabilities
)

local on_attach = require('lsp/on_attach')
local installed_servers = require("nvim-lsp-installer.servers").get_installed_server_names()
local lspconfig = require("lspconfig")



for _, server in pairs(installed_servers) do
    local conf = {
        on_attach = on_attach,
        capabilities = cmp_capabilities,
    }
    local has_opts, opts = pcall(require, "lsp/servers/" .. server)
    if has_opts then
        conf.root_dir = opts.root_dir
        conf.settings = opts.opts
        conf.filetypes = opts.filetypes
    end
    lspconfig[server].setup(conf)
end

require("null-ls").setup({
    defaults = {
        on_attach = on_attach,
        diagnostics_format = "[#{c}] #{m} (#{s})",
        fallback_severity = vim.diagnostic.severity.WARNING,
    }
})
require("null-ls").register(require("lsp/servers/null_ls"))
