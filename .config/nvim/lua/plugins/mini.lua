return {
    {
        'echasnovski/mini.nvim',
        version = false,
        event = "BufReadPre",
        config = function()
            require("mini.files").setup({ windows = { preview = true } })
            require("mini.comment").setup()
            require("mini.pairs").setup()
            require("mini.move").setup()
            require("mini.surround").setup()
            require("mini.splitjoin").setup()
            require("mini.bracketed").setup()
            require("mini.operators").setup()
            require("mini.notify").setup()
            require("mini.diff").setup()
            require("mini.jump").setup()
            require("mini.jump2d").setup()

            local miniclue = require('mini.clue')
            miniclue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },

                    -- Built-in completion
                    { mode = 'i', keys = '<C-x>' },

                    -- `g` key
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },

                    -- Marks
                    { mode = 'n', keys = "'" },
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = "'" },
                    { mode = 'x', keys = '`' },

                    -- Registers
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },

                    -- Window commands
                    { mode = 'n', keys = '<C-w>' },

                    -- `z` key
                    { mode = 'n', keys = 'z' },
                    { mode = 'x', keys = 'z' },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
            })

            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    warn      = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsHack' },
                    warning   = { pattern = '%f[%w]()WARNING()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })

            require("mini.pick").setup()
        end,
        keys = {
            { "<leader>e",  function() require("mini.files").open(vim.fn.expand("%")) end, desc = "[E]xplore" },
            { "<leader>ff", "<cmd>Pick files<cr>",                                         desc = "[F]ind [F]iles" },
            { "<leader>fb", "<cmd>Pick buffers<cr>",                                       desc = "[F]ind [B]uffers" },
            { "<leader>fb", "<cmd>Pick buffers<cr>",                                       desc = "[F]ind [B]uffers" },
            { "<leader>fr", "<cmd>Pick resume<cr>",                                        desc = "[F]ind [R]esume" },
            { "<leader>fs", "<cmd>Pick grep_live<cr>",                                     desc = "[F]ind [S]tring" },
            { "<leader>fg", "<cmd>Pick grep<cr>",                                          desc = "[F]ind [G]rep" },
        }
    },

}
