function `gs
    set file (git status --porcelain  | sed s/^...// | fzf)
    cd (git rev-parse --show-cdup)
    nvim_opener $file
end
