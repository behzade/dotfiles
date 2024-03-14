return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = {
                    enable = true,
                },
                -- indent = {
                --     enable = true,
                -- },
                autotag = {
                    enable = true,
                    filetypes = { "html", "xml", "php", "vue", "twig", "tsx", "jsx", "typescriptreact" },
                },
                textobjects = {
                    select = {
                        enable = true,

                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["as"] = "@class.outer",
                            ["is"] = "@class.inner",
                            ["ac"] = "@call.outer",
                            ["ic"] = "@call.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["a,"] = "@parameter.outer",
                            ["i,"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]s"] = "@class.outer",
                            ["]c"] = "@call.outer",
                            ["]l"] = "@loop.outer",
                            ["]i"] = "@conditional.outer",
                            ["],"] = "@parameter.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[s"] = "@class.outer",
                            ["[c"] = "@call.outer",
                            ["[l"] = "@loop.outer",
                            ["[i"] = "@conditional.outer",
                            ["[,"] = "@parameter.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "single",
                        peek_definition_code = {
                            ["gh"] = "@function.outer",
                        },
                    },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = "<S-CR>",
                        node_decremental = "<BS>",
                    },
                },
            })

            vim.treesitter.language.register('templ', 'templ')
        end
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
}
