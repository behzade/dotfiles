function nvim_opener 
    if not test -n "$argv"
        echo 'no file selected'
        return
    end
    switch $argv
    case "*:*"
        set parameters (string split : $argv)
        commandline "nvim +$parameters[2] $parameters[1]"
    case "*"
        commandline "nvim $argv"
    end

    commandline -f execute
end
