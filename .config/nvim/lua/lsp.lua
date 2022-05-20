require("lsp/style")
require("nvim-lsp-installer").setup({})

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)
local on_attach = require('lsp/on_attach')
local installed_servers = require("nvim-lsp-installer.servers").get_installed_server_names()
local lspconfig = require("lspconfig")



for _,server in pairs(installed_servers) do
    local conf = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    local has_opts, opts = pcall(require, "lsp/servers/" .. server)
    vim.pretty_print(opts)
    if has_opts then
        conf.root_dir = opts.root_dir
        conf.settings = opts.opts
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
