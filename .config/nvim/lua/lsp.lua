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
    lspconfig[server].setup(server_conf(server))
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

local null_ls = require("null-ls")


local home_bin = os.getenv("HOME") .. "/.local/bin/"

if os.getenv("PHP_VENDOR_DIR") then
    null_ls.register(
        null_ls.builtins.diagnostics.phpstan.with({
            command = home_bin .. "phpstan",
            extra_args = { "-l", "2" },
        })
    )
    -- null_ls.register(null_ls.builtins.diagnostics.phpmd)
    null_ls.register(null_ls.builtins.diagnostics.phpcs)
    null_ls.register(null_ls.builtins.formatting.phpcbf)
end

null_ls.register(null_ls.builtins.diagnostics.twigcs)
null_ls.register(null_ls.builtins.formatting.shfmt)

null_ls.setup({
    defaults = {
        on_attach = on_attach,
        capabilities = capabilities,
        fallback_severity = vim.diagnostic.severity.WARN,
    },
})
