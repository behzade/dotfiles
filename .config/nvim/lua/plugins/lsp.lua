return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            local lspconfig = require("lspconfig")


            local lsp = vim.lsp

            local on_attach = require("util/lsp").on_attach
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
                border = "single",
            })
            lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
                border = "single",
            })
            lsp.handlers["textDocument/previewLocation"] = lsp.with(lsp.handlers.preview_location, {
                border = "single",
            })

            local function server_conf(name)
                local has_opts, opts = pcall(require, "plugins/servers/" .. name)
                local config = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }

                if not has_opts then
                    return config
                end


                for k, v in pairs(opts) do
                    config[k] = v
                end

                return config
            end

            for _, server in pairs(require("mason-lspconfig").get_installed_servers()) do
                lspconfig[server].setup(server_conf(server))
            end
            lspconfig.rust_analyzer.setup({
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                    },
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }) -- TODO: better config for non installed through mason servers

            lspconfig.gleam.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig.protols.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig.csharp_ls.setup(
                {
                    on_attach = on_attach,
                    capabilities = capabilities,
                })

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
        "j-hui/fidget.nvim",
        branch = "legacy",
        config = function()
            require('fidget').setup()
        end
    },
    {
        'Decodetalkers/csharpls-extended-lsp.nvim',
    }
}
