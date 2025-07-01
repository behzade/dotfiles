return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme gruvbox]]
        end,
        opts = {
            contrast = "hard",
        }
    },
    "tpope/vim-repeat",
    "tpope/vim-rsi",
    "wellle/targets.vim",
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                globalstatus = true,
            },
            tabline = {
                lualine_a = { 'buffers' },
                lualine_b = { 'lsp_status`' },
                lualine_z = { 'tabs' }
            }
        },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
                tabline = {
                    lualine_a = { 'buffers' },
                    lualine_b = { 'lsp_status`' },
                    lualine_z = { 'tabs' }
                }
            })
            for i = 1, 9 do
                vim.keymap.set('n', '<leader>b' .. i, '<Cmd>LualineBuffersJump ' .. i .. '<CR>',
                    { noremap = true, silent = true, desc = "Go to [B]uffer [" .. i .. "]" })
            end
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },
    {
        'stevearc/conform.nvim',
        opts = {
        },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                        timeout_ms = 1000,
                    })
                end,
                desc = "[L]sp [F]ormat"
            },
        },
    },
    {
        'MagicDuck/grug-far.nvim',
        opts = {},
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            log_level = 'error',
            auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "supermaven-inc/supermaven-nvim",
        opts = {
        }
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    }

}
