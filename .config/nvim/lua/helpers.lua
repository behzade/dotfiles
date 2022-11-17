function ParentDir(dir, level)
    local parent = string.sub(dir, 0, string.find(dir, "/[^/]*$") - 1)
    if level == 1 then
        return parent
    else
        return ParentDir(parent, level - 1)
    end
end
