return {
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

            local function server_conf(name)
                local has_opts, opts = pcall(require, "plugins/servers/" .. name)
                if not has_opts then
                    vim.notify("Invalid config for " .. name, vim.log.levels.ERROR)
                    return {}
                end
                opts.on_attach = on_attach
                opts.capabilities = capabilities

                return opts
            end

            local utils = require("util.files")
            for _, server in pairs(utils.get_files_in_config_dir('plugins/servers')) do
                vim.lsp.config(server, server_conf(server))
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
