return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
        provider = "gemini",
        gemini = {
            -- model = "gemini-2.0-flash",
            model = "gemini-2.5-pro-exp-03-25",
        },
        behaviour = {
            enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
        }
        -- vendors = {
        --     openrouter = {
        --         __inherited_from = 'openai',
        --         endpoint = 'https://openrouter.ai/api/v1',
        --         api_key_name = 'OPENROUTER_API_KEY',
        --         model = 'deepseek/deepseek-chat',
        --     },
        -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
