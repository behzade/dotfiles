require("lsp/style")
require("nvim-lsp-installer").setup({})

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
local on_attach = require('lsp/on_attach')
local installed_servers = require("nvim-lsp-installer.servers").get_installed_server_names()
local lspconfig = require("lspconfig")



for _,server in pairs(installed_servers) do
    conf = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    has_opts, opts = pcall(require, "lsp/servers/" .. server)
    if has_conf then
        conf["settings"] = opts
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
null_sources = require("lsp/servers/null_ls")
require("null-ls").register(null_sources)
