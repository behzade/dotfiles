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

            local lsp_util = require("util/lsp")

            local on_attach = lsp_util.on_attach

            local function server_conf(name)
                local has_opts, opts = pcall(require, "plugins/servers/" .. name)
                local config = {
                    on_attach = on_attach,
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
        'Decodetalkers/csharpls-extended-lsp.nvim',
    }
}
