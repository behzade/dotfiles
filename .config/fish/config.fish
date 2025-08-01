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

export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey, export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

export GPG_TTY=(tty)

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.cache/.bun/bin"

export QT_QPA_PLATFORMTHEME=qt6ct

export LS_COLORS=(vivid generate gruvbox-dark)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview="bat --color=always {}"'
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export ZK_NOTEBOOK_DIR=$HOME/Documents/ze


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

starship init fish | source
zoxide init fish | source

if test (tty) = "/dev/tty1"
    uwsm start default
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
