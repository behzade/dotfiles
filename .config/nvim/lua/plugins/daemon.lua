-- Inside your lazy.nvim plugins list
return {
    {
        -- Tell lazy where the plugin source is
        dir = '~/.config/nvim/lua/local_plugins/daemon',

        -- Configure it AFTER it's loaded
        config = function()
            -- Use the correct Lua module path to load the init.lua file
            require('local_plugins.daemon').setup()
        end,

        -- Optional: If you want to load it on a command or event
        -- cmd = "CursorCloneShowSidebar",
        -- event = "VeryLazy",
    }
}
