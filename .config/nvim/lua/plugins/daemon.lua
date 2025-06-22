return {
    {
        dir = '~/Projects/personal/plugin-workshop/daemon',

        config = function()
            require('daemon').setup()
            -- require('daemon').setup({
            --     use_rust = true,
            --     rust_lib_path = '/Users/behzad/Projects/personal/plugin-workshop/daemon/target/release/libdaemon.dylib', -- Specify the path to the .dylib file
            -- })
        end,

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
        }
    }
}
