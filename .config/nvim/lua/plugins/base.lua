return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd [[colorscheme tokyonight]]
        end
    },
    "tpope/vim-repeat",
    "tpope/vim-rsi",
    "wellle/targets.vim",
    "stevearc/dressing.nvim",
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                globalstatus = true,
            },
        },
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
        "supermaven-inc/supermaven-nvim",
        opts = {}
    },
    {
        'akinsho/toggleterm.nvim',
        opts = {
            open_mapping = [[<c-\>]],
            direction = "float",
        },
        keys = {
            {
                "<leader>gg",
                function()
                    require("util.lazygit").lazygit_toggle()
                end,
                desc = "Lazy[G]it",
            }
        },
    },
    {
        'rmagatti/auto-session',
        event = "VeryLazy", -- IMPORTANT: Lazy-load it so it doesn't slow startup
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
}
