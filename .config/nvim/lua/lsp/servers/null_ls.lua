if not require("nvim-lsp-installer.servers").is_server_installed("intelephense") then
    return {}
end

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local null_ls = require("null-ls")
local DIAGNOSTICS = methods.internal.DIAGNOSTICS
local filename = vim.api.nvim_buf_get_name(0)
local home_bin = os.getenv("HOME") .. "/.local/bin/"

local phpstan_source = {
    name = "phpstan-remote",
    method = DIAGNOSTICS,
    filetypes = { "php" },
    generator = null_ls.generator({
        command = home_bin .. "phpstan",
        args = { "analyze", "--error-format", "json", "--no-progress", filename },
        format = "json_raw",
        check_exit_code = function(code)
            return code <= 1
        end,
        on_output = function(params)
            local parser = h.diagnostics.from_json({})
            params.messages = params.output
                and params.output.files
                and params.output.files[filename]
                and params.output.files[filename].messages
                or {}

            return parser({ output = params.messages })
        end,
    }),
}
local php_source = null_ls.builtins.diagnostics.php.with({
    command = home_bin .. "php",
})

local phpcs_source = null_ls.builtins.diagnostics.phpcs.with({
    command = home_bin .. "phpcs",
    args = {
        "--report=json",
        "--standard=/var/www/vendor/digikala/supernova/cs_ruleset.xml",
        "-s",
        "-",
    },
})

local phpcbf_source = null_ls.builtins.formatting.phpcbf.with({
    command = home_bin .. "phpcbf",
    args = {
        "--standard=/var/www/vendor/digikala/supernova/cs_ruleset.xml",
    },
})

return {
    php_source,
    -- phpstan_source,
    phpcs_source,
    phpcbf_source,
}
