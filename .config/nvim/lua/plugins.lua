local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


return require("lazy").setup({
    "samjwill/nvim-unception",
    "nvim-lua/plenary.nvim",
    "tpope/vim-repeat",
    "tpope/vim-rsi",
    "wellle/targets.vim",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-textobjects",
    "ggandor/lightspeed.nvim",
    "stevearc/dressing.nvim",
    "vim-scripts/restore_view.vim",
    "vim-scripts/ReplaceWithRegister",
    "nvim-tree/nvim-web-devicons",
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        build = ":MasonUpdate",
        config = function()
            require('lsp')
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
            },
        },
        config = require("telescope-conf"),
    },
    {
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
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    },
    {
        'folke/todo-comments.nvim',
        config = function()
            require("todo-comments").setup({})
        end,
    },
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
            require("completion-conf")
        end,
    },
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                ignore_lsp = { "phpactor", "intelephense" },
                detection_methods = { "pattern", "lsp" }
            })
        end,
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
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
        },
        config = function()
            require("go").setup({
                lsp_cfg = {
                    capabilities = require("lsp/capabilities"),
                    on_attach = require("lsp/on_attach")
                },
                lsp_gofumpt = true,
                lsp_inlay_hints = {
                    enable = true,
                }
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    'nvim-pack/nvim-spectre',
    'Decodetalkers/csharpls-extended-lsp.nvim',
    "vrischmann/tree-sitter-templ",
    {
        'ellisonleao/gruvbox.nvim',
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            vim.env["HTTPS_PROXY"] = "http://localhost:10809"
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                }
            })
        end,
    },
})
