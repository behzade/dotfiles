return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            require 'luasnip'.filetype_extend("twig", { "twig" })

            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                    ["<s-tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" })
                },
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "treesitter" },
                    { name = "buffer" },
                    { name = "lazydev"},
                }),
                completion = {
                    keyword_length = 1,
                }
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline("/", {
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            local keymap = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }
            keymap("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
            keymap("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
            keymap("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
            keymap("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
        end,
    },
}
