return {
    default_config = {
        cmd = { 'biome', 'lsp-proxy' },
        filetypes = {
            'astro',
            'css',
            'graphql',
            'javascript',
            'javascriptreact',
            'json',
            'jsonc',
            'svelte',
            'typescript',
            'typescript.tsx',
            'typescriptreact',
            'vue',
        },
        root_dir = function(fname)
            local root_files = { ".git" }
            return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
        end,
        single_file_support = false,
    },
    docs = {
        description = [[
https://biomejs.dev

Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).

```sh
npm install [-g] @biomejs/biome
```
]],
    },
}
