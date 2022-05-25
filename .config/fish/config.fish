export XDG_SESSION_TYPE='wayland' 
export XDG_CURRENT_DESKTOP='sway'
export EDITOR='nvim'
export VISUAL=$EDITOR
export OPENER='xdg-open'
export ZK_NOTEBOOK_DIR="$HOME/Documents/ZK"
# Python
export PROJECT_HOME=~/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=~/.virtualenvs

export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey, export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

export GPG_TTY=(tty)

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH="$PATH:/opt/context-minimals/texmf-linux-64/bin"
export TEXMF="/usr/share/context"
export JAVA_OPTS="-XX:+IgnoreUnrecognizedVMOptions"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
export ANDROID_HOME="/opt/android-sdk"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/tools/"
export PATH="$PATH:$ANDROID_HOME/emulator/"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export FLUTTER_HOME=/opt/flutter
export PATH="$PATH:$FLUTTER_HOME/bin"
export LS_COLORS="(vivid generate ayu)"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export ANDROID_SDK_ROOT=/opt/android-sdk

export LF_ICONS=(sed ':a;N;$!ba;s/\n//g' ~/.config/diricons)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

alias sudo="sudo "
alias mv="mv -i"
alias vim="nvim"
alias tmux="tmux -2"
alias mux="tmuxinator"
alias top="btop"
alias icat="kitty +kitten icat"
alias ssh="kitty +kitten ssh"
alias off="swaymsg output VGA-1 dpms off"
alias on="swaymsg output VGA-1 dpms on"
# general use
alias ls='exa --icons'                                                 # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGd --git --sort=modified'                            # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# specialty views
alias lS='exa -1'                                                       # one column, just names
alias lt='exa --tree --level=2'                                         # tree
alias ncmpcpp='ncmpcpp --quiet'

alias run='make run'
alias cider='clj -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --interactive'

function launch
    nohup $1 >/dev/null 2>/dev/null & disown;
end

if test (tty) = "/dev/tty1"
  dbus-run-session sway
end

function `e () 
  nvim +noswapfile +"setlocal buftype=nofile" +"setlocal bufhidden=hide" $argv
end

function `gs
    set file (git status --porcelain  | sed s/^...// | fzf)
    nopener $file
end

function `ff
    set file (fzf)
    nopener $file
end

function `fg
    if not test -n "$argv"
        echo 'must pass an argument'
        return
    end
    set file (rg -Sl $argv | fzf)
    nopener $file
end

function `fz
    set file (z -l | fzf)
    nopener $file
end

function nopener 
    if not test -n "$argv"
        echo 'no file selected'
        return
    end
    nvim "$argv"
end

function vimrc 
    pushd ~/.config/nvim
    nvim init.lua
    popd
end


export PHPSTORM_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/phpstorm.vmoptions"
export GATEWAY_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/gateway.vmoptions"
export JETBRAINS_CLIENT_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/jetbrains_client.vmoptions"
export JETBRAINSCLIENT_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/jetbrainsclient.vmoptions"
export DATAGRIP_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/datagrip.vmoptions"
export APPCODE_VM_OPTIONS="/home/behzad/Projects/ja-netfilter/vmoptions/appcode.vmoptions"
