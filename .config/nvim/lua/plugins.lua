vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
    use({
        "wbthomason/packer.nvim",
        "nvim-lua/plenary.nvim",
        "tpope/vim-repeat",
        "tpope/vim-surround",
        "tpope/vim-dispatch",
        "radenling/vim-dispatch-neovim",
        "wellle/targets.vim",
        "lukas-reineke/indent-blankline.nvim",
        "p00f/nvim-ts-rainbow",
        "neovim/nvim-lspconfig",
        "williamboman/nvim-lsp-installer",
        { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
        "nvim-treesitter/nvim-treesitter-textobjects",
        "ggandor/lightspeed.nvim",
        "stevearc/dressing.nvim",
        "vim-scripts/restore_view.vim",
        "windwp/nvim-autopairs",
        "nelsyeung/twig.vim",
        "jose-elias-alvarez/null-ls.nvim",
        "projekt0n/github-nvim-theme",
    })

    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require('telescope-conf').init()
        end,
        requires = {
            "romgrk/fzy-lua-native",
            "nvim-telescope/telescope-fzy-native.nvim",
        }
    })
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
                    delay = 1000,
                    ignore_whitespace = true,
                },
                current_line_blame = false,
            })
        end,
    })

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    })

    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
            })
        end,
    })

    use({
        "folke/todo-comments.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
    })

    use({
        "sidebar-nvim/sidebar.nvim",
        config = function()
            local sidebar = require("sidebar-nvim")
            local sidebar_lib = require("sidebar-nvim.lib")
            local opts = {
                open = true,
                sections = {
                    "files",
                    "git",
                    "containers"
                },
            }
            sidebar.setup(opts)
            vim.api.nvim_create_autocmd(
                "BufEnter",
                { pattern = "*", callback = sidebar_lib.update }
            )
        end,
    })
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("completion")
        end,
    })
    use({
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                ignore_lsp = { "null-ls", "phpactor", "intelephense" }
            })
        end,
    })
    use {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup {}
        end
    }
    use {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
        end
    }

end)
