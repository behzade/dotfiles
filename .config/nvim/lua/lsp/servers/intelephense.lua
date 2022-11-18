local file_dir = ParentDir(vim.api.nvim_buf_get_name(0), 1)
local git_root = vim.fn.system("cd ".. file_dir .. " && " .."git rev-parse --show-toplevel")
return {
    root_dir = function() return ParentDir(git_root, 2) end,
}

