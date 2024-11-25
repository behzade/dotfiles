export XDG_SESSION_TYPE='wayland' 
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
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

export LS_COLORS=(vivid generate ayu)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden'


export LF_ICONS=(sed ':a;N;$!ba;s/\n//g' ~/.config/diricons)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

alias sudo="sudo "
alias mv="mv -i"
alias vim="nvim"
alias top="btop"
alias icat="kitty +kitten icat"
alias ssh="kitty +kitten ssh"
# general use
alias ls='exa --icons --group-directories-first --hyperlink'                                                 # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGd --git --sort=modified'                            # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# specialty views
alias lS='exa -1'                                                       # one column, just names
alias lt='exa --tree --level=2'                                         # tree

alias run='make run'

alias dr='devbox run'

starship init fish | source
zoxide init fish | source

direnv hook fish | source

if test -f "$HOME/.config/fish/local.fish"
    source "$HOME/.config/fish/local.fish"
end

if test (tty) = "/dev/tty1"
    uwsm start default
end
