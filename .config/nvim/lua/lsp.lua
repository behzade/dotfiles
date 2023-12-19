require("lsp/style")
require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")

local on_attach = require('lsp/on_attach')
local capabilities = require('lsp/capabilities')


local function server_conf(name)
    local has_opts, opts = pcall(require, "lsp/servers/" .. name)
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
    if server == "gopls" then
        goto continue
    end
    lspconfig[server].setup(server_conf(server))
    ::continue::
end

lspconfig["rust_analyzer"].setup(
    {
        cmd = {
            "rustup", "run", "stable", "rust-analyzer"
        },
        on_attach = on_attach,
        capabilities = capabilities,
    }
)

-- vim.tbl_deep_extend('keep',lspconfig, {
--     defold = {
--         cmd = {'command'},
--         filetypes = "defold",
--         name = "defold"
--     }
-- })

vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

vim.filetype.add({
    extension = {
        script = "lua",
    },
})

vim.filetype.add({
    extension = {
        gui_script = "lua",
    },
})
