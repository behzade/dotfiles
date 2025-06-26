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

            local lsp_util = require("util.lsp")

            local on_attach = lsp_util.on_attach
            local capabilities = vim.lsp.protocol.make_client_capabilities()
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


            local utils = require("util.files")
            for _, server in pairs(utils.get_files_in_config_dir('plugins/servers')) do
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
        'Decodetalkers/csharpls-extended-lsp.nvim',
    }
}
