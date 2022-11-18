function ParentDir(dir, level)
    local parent = string.sub(dir, 0, string.find(dir, "/[^/]*$") - 1)
    if level == 1 then
        return parent
    else
        return ParentDir(parent, level - 1)
    end
end

function Html()
    vim.api.nvim__screenshot("/tmp/nvim-screenshot")
    os.execute("cat /tmp/nvim-screenshot | aha --black > /tmp/nvim-screenshot.html")
end
