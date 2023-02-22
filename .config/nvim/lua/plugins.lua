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
        "wellle/targets.vim",
        "lukas-reineke/indent-blankline.nvim",
        { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
        "nvim-treesitter/nvim-treesitter-textobjects",
        "ggandor/lightspeed.nvim",
        "stevearc/dressing.nvim",
        "vim-scripts/restore_view.vim",
        "windwp/nvim-autopairs",
        "nelsyeung/twig.vim",
        "jose-elias-alvarez/null-ls.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = 'make' },
        "vim-scripts/ReplaceWithRegister",
        "mbbill/undotree",
        "direnv/direnv.vim",
        "projekt0n/github-nvim-theme",
        "nanotee/zoxide.vim",
    })

    use {
        "mcchrish/zenbones.nvim",
        -- Optionally install Lush. Allows for more configuration or extending the colorscheme
        -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
        -- In Vim, compat mode is turned on as Lush only works in Neovim.
        requires = "rktjmp/lush.nvim"
    }
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        config = function()
            require('lsp').setup()
        end
    }

    use({
        "nvim-telescope/telescope.nvim",
        config = require("telescope-conf"),
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
                current_line_blame = true,
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

    use {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    }

    use({
        'folke/todo-comments.nvim',
        config = function()
            require("todo-comments").setup({})
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
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end
    }

    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    }

    use {
        "SmiteshP/nvim-navic",
        config = function()
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
    }

    use {
        "samjwill/nvim-unception",
        config = function()
            vim.g.unception_delete_replaced_buffer = true
        end
    }

    use {
        "Shatur/neovim-ayu",
        config = function()
            -- vim.cmd([[colorscheme ayu-mirage]])
        end
    }

    use {
        "j-hui/fidget.nvim",
        config = function()
            require('fidget').setup()
        end
    }

    use {
        "rest-nvim/rest.nvim",
        config = function()
            require('rest-nvim').setup()
        end

    }
end)
