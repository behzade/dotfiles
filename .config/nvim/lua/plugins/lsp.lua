return {
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()

            local lsp_util = require("util.lsp")

            local on_attach = lsp_util.on_attach
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.semanticTokensProvider = nil


            for _, server in pairs(
                { "lua_ls", "biome", "emmet_language_server", "gopls", "html", "intelephense", "lua_ls", "ruff", "rust_analyzer", "sumneko_lua", "tailwindcss", "ts_ls", "ty", "zk" }
            ) do
                vim.lsp.config(server, { on_attach = on_attach, capabilities = capabilities })
                vim.lsp.enable(server)
            end

            vim.filetype.add({
                extension = {
                    templ = "templ",
                },
            })
        end
    },
    {
        "SmiteshP/nvim-navic",
        config = function()
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
    },
    {
        'Decodetalkers/csharpls-extended-lsp.nvim',
    }
}
