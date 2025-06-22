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

            local on_attach = require("util/lsp").on_attach
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

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
                vim.lsp.config(server, server_conf(server))
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
