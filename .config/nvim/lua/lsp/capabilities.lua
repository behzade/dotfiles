local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return require('cmp_nvim_lsp').update_capabilities(
    capabilities
)
