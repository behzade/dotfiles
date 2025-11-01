return {
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup()

            local lsp_util = require("util.lsp")
            local on_attach = lsp_util.on_attach
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.semanticTokensProvider = nil

            local function with_server_overrides(server, base)
                local ok, server_opts = pcall(require, "lsp.servers." .. server)
                if ok then
                    return vim.tbl_deep_extend("force", base, server_opts)
                end
                return base
            end

            local installed_servers = mason_lspconfig.get_installed_servers()
            if vim.tbl_isempty(installed_servers) then
                vim.notify("Mason has no installed LSP servers to enable.", vim.log.levels.INFO, { title = "LSP" })
            end

            for _, server in ipairs(installed_servers) do
                local server_opts = with_server_overrides(server, {
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                local ok, err = pcall(vim.lsp.config, server, server_opts)
                if not ok then
                    vim.notify(string.format("Unable to configure %s: %s", server, err), vim.log.levels.WARN, { title = "LSP" })
                else
                    local enable_ok, enable_err = pcall(vim.lsp.enable, server)
                    if not enable_ok then
                        vim.notify(string.format("Unable to enable %s: %s", server, enable_err), vim.log.levels.WARN, { title = "LSP" })
                    end
                end
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
