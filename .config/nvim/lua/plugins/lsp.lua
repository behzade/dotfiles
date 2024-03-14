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
            local set = vim.keymap.set
            local telescope = require("telescope.builtin")
            local navic = require("nvim-navic")

            local style_opts = {
                fname_width = 90,
            }

            local lsp_references = function() telescope.lsp_references(style_opts) end
            local lsp_implementations = function() telescope.lsp_implementations(style_opts) end
            local lsp_dynamic_workspace_symbols = function() telescope.lsp_dynamic_workspace_symbols(style_opts) end

            local function on_list(options)
                vim.fn.setqflist({}, ' ', options)
                vim.api.nvim_command('silent cfirst')
            end

            local diagnostic = vim.diagnostic
            local diagnostic_opts = { float = { border = "single" } }

            local next = function() diagnostic.goto_next(diagnostic_opts) end
            local prev = function() diagnostic.goto_prev(diagnostic_opts) end

            local on_attach = function(client, bufnr)
                set("n", "K", lsp.buf.hover)
                set("n", "gd", function() lsp.buf.definition({ reuse_win = true, on_list = on_list }) end)
                set("n", "gD", lsp_references)
                set("n", "[d", prev)
                set("n", "]d", next)
                set("n", "<leader>lr", lsp.buf.rename)
                set("n", "<leader>la", lsp.buf.code_action)
                set("n", "<leader>ll", lsp.codelens.run)
                set("n", "<leader>li", lsp_implementations)
                set("n", "<leader>ls", lsp_dynamic_workspace_symbols)
                set("n", "<leader>ld", telescope.diagnostics)

                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

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
}
