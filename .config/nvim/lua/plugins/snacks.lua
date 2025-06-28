return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            lazygit = { enabled = true },
            terminal = { enabled = true },
        },
        keys = {

            { "<leader>ff", function() Snacks.picker.smart() end,               desc = "[F]ind [F]iles" },
            { "<leader>fb", function() Snacks.picker.buffers() end,             desc = "[F]ind [B]uffers" },
            { "<leader>fr", function() Snacks.picker.resume() end,              desc = "[F]ind [R]esume" },
            { "<leader>fs", function() Snacks.picker.grep() end,                desc = "[F]ind [S]tring" },
            { "<leader>fg", function() Snacks.picker.grep_word() end,           desc = "[F]ind [G]rep" },
            { "<leader>fh", function() Snacks.picker.help() end,                desc = "[F]ind [H]elp" },

            { "<leader>gb", function() Snacks.picker.git_branches() end,        desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end,             desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line() end,        desc = "Git Log Line" },
            { "<leader>gs", function() Snacks.picker.git_status() end,          desc = "Git Status" },
            { "<leader>gS", function() Snacks.picker.git_stash() end,           desc = "Git Stash" },
            { "<leader>gd", function() Snacks.picker.git_diff() end,            desc = "Git Diff (Hunks)" },
            { "<leader>gf", function() Snacks.picker.git_log_file() end,        desc = "Git Log File" },
            { "<leader>gg", function() Snacks.lazygit.open() end,               desc = "Lazygit" },

            { [[<c-\>]],    function() Snacks.terminal.toggle() end,            desc = "Toggle Terminal", mode = {"n", "i", "t"} },

            { "<leader>ld", function() Snacks.picker.diagnostics() end,         desc = "[L]sp [D]iagnostics" },
            { "gD",         function() Snacks.picker.lsp_references() end,      nowait = true,                   desc = "References" },
            { "<leader>ls", function() Snacks.picker.lsp_symbols() end,         desc = "[L]sp [S]ymbols" },
            { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "[L]sp [I]mplementations" },
        }
    },
}
