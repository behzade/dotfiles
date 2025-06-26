local function setup_cmd_autocomplete()
    local term = vim.api.nvim_replace_termcodes('<C-z>', true, true, true)
    vim.opt.wildmenu = true
    vim.opt.wildoptions = 'pum,fuzzy'
    vim.opt.wildmode = 'noselect:lastused,full'
    vim.opt.wildcharm = vim.fn.char2nr(term)

    vim.keymap.set('c', '<Up>', '<End><C-U><Up>', { silent = true })
    vim.keymap.set('c', '<Down>', '<End><C-U><Down>', { silent = true })

    vim.api.nvim_create_autocmd('CmdlineChanged', {
        pattern = ':',
        callback = function()
            local cmdline = vim.fn.getcmdline()
            local curpos = vim.fn.getcmdpos()
            local last_char = cmdline:sub(-1)

            if
                curpos == #cmdline + 1
                and vim.fn.pumvisible() == 0
                and last_char:match('[%w%/%: ]')
                and not cmdline:match('^%d+$')
            then
                vim.opt.eventignore:append('CmdlineChanged')
                vim.api.nvim_feedkeys(term, 'ti', false)
                vim.schedule(function()
                    vim.opt.eventignore:remove('CmdlineChanged')
                end)
            end
        end,
    })
end

local function setup_clue()
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
end

local function setup_hipatterns()
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
end

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
            require("mini.notify").setup()
            require("mini.diff").setup()
            require("mini.jump").setup()
            require("mini.jump2d").setup()
            require("mini.completion").setup()
            vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { noremap = true, expr = true })
            vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })

            setup_cmd_autocomplete()
            setup_clue()
            setup_hipatterns()

            require("mini.snippets").setup()
            require("mini.pick").setup()
            require("mini.extra").setup()
        end,
        keys = {
            { "<leader>e",   function() require("mini.files").open(vim.fn.expand("%")) end, desc = "[E]xplore" },
            { "<leader>ff",  "<cmd>Pick files<cr>",                                         desc = "[F]ind [F]iles" },
            { "<leader>fb",  "<cmd>Pick buffers<cr>",                                       desc = "[F]ind [B]uffers" },
            { "<leader>fr",  "<cmd>Pick resume<cr>",                                        desc = "[F]ind [R]esume" },
            { "<leader>fs",  "<cmd>Pick grep_live<cr>",                                     desc = "[F]ind [S]tring" },
            { "<leader>fg",  "<cmd>Pick grep<cr>",                                          desc = "[F]ind [G]rep" },
            { "<leader>fo",  "<cmd>Pick options<cr>",                                       desc = "[F]ind [O]ptions" },
            { "<leader>fh",  "<cmd>Pick help<cr>",                                          desc = "[F]ind [H]elp" },

            { "<leader>gc", "<cmd>Pick git_commits<cr>",                                   desc = "[G]it [C]ommits" },
            { "<leader>gh", "<cmd>Pick git_hunks<cr>",                                     desc = "[G]it [H]unks" },
            { "<leader>gb", "<cmd>Pick git_branches<cr>",                                  desc = "[G]it [B]ranches" },

            { "<leader>ld",  "<cmd>Pick diagnostic<cr>",                                    desc = "[L]sp [D]iagnostics" },
            { "gD",          '<cmd>Pick lsp scope="references"<cr>',                        desc = "Lsp References" },
            { "<leader>ls",  '<cmd>Pick lsp scope="workspace_symbol"<cr>',                  desc = "[L]sp [S]ymbols" },
            { "<leader>li",  '<cmd>Pick lsp scope="implementation"<cr>',                    desc = "[L]sp [I]mplementations" },
        }
    },

}
