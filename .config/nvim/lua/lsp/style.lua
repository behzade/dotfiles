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
