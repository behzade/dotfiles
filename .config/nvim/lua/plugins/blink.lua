return {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = function(_, opts)
            opts = opts or {}
            opts.keymap = { preset = 'enter' }
            opts.appearance = opts.appearance or {}
            -- Only appearance-related overrides belong here.
            opts.appearance.nerd_font_variant = opts.appearance.nerd_font_variant or 'mono'
            opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
                documentation = { auto_show = true },
            })
            opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            })
            opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
                implementation = "prefer_rust_with_warning",
            })
            return opts
        end
    }
}
