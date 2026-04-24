if test -f "$HOME/.config/fish/local.fish"
    source "$HOME/.config/fish/local.fish"
end

export ELECTRON_OZONE_PLATFORM_HINT=auto
export XDG_SESSION_TYPE='wayland' 
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR='nvim'
export VISUAL=$EDITOR
export OPENER='xdg-open'
# Python
export PROJECT_HOME=~/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALFISH_HOME="$XDG_DATA_HOME/virtualenvs"

set -gx LESSKEY "$XDG_CONFIG_HOME/less/lesskey"
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less/history"

export GPG_TTY=(tty)

fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.cache/.bun/bin

set -l cleaned_path
for p in $PATH
    if contains -- $p /Users/behzad/.opencode/bin /Users/behzad/.lmstudio/bin /Applications/Ghostty.app/Contents/MacOS
        continue
    end

    if not contains -- $p $cleaned_path
        set cleaned_path $cleaned_path $p
    end
end
set -gx PATH $cleaned_path

export QT_QPA_PLATFORMTHEME=qt6ct

export LS_COLORS=(vivid generate gruvbox-dark)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview="bat --color=always {}"'
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
if test -d /Volumes/zk
    set -gx ZK_NOTEBOOK_DIR /Volumes/zk
else
    set -e ZK_NOTEBOOK_DIR
end


set -x LF_ICONS (tr -d '\n' < ~/.config/diricons)

alias sudo="sudo "
alias mv="mv -i"
alias vim="nvim"
alias top="btop"
# general use
alias ls='eza --icons --group-directories-first'                                                 # ls
alias l='eza -lbF --git'                                               # list, size, type, git
alias ll='eza -lbGF --git'                                             # long list
alias llm='eza -lbGd --git --sort=modified'                            # long list, modified date sort
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list
alias nv='open -a neovide .'

# specialty views
alias lS='eza -1'                                                       # one column, just names
alias lt='eza --tree --level=2'                                         # tree

alias run='make run'

alias dr='devbox run'
alias xargs='xargs '

starship init fish | source
zoxide init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin
