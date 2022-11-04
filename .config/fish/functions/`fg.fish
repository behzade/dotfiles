function `fg
    if not test -n "$argv"
        echo 'must pass an argument'
        return
    end
    set file (rg -S --no-heading --line-number $argv | cut -d':' -f1-2 | fzf)
    nvim_opener $file
end
