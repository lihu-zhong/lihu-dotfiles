# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# local-specific stuff
if [ -f ~/.local_bashrc ]; then
    . ~/.local_bashrc
fi

# User specific environment and startup programs

alias cat='bat'
alias cdl='cd "$(ls -d ./* | tail -1)"'
alias fuck='sudo $(history -p \!\!)'
alias icat='kitty +kitten icat'
alias kclip='kitty +kitten clipboard'
alias kdiff='kitty +kitten diff'
alias kssh='kitty +kitten ssh'
alias nv='nvim'
alias pv='poetry run vim'
alias sauce='source ~/.bashrc'
alias ls='eza'
alias sl='echo "lol u suck @ tiping"; ls'

function dg() {
    grep "$@" /usr/share/dict/words
}

function parse-git-branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# cribbed from https://stackoverflow.com/a/16715681
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'

    PS1="\[\e[0;97m\]@\[\e[0m\e[32m\]\h:\[\e[36;3m\]\w\[\e[33m\]\$(parse-git-branch) "
    if [ $EXIT != 0 ]; then
        PS1+="${Red}${EXIT}${RCol}\n$ "      # Add red if exit code non 0
    else
        PS1+="${Gre}${EXIT}${RCol}\n$ "
    fi

    # Set the window title to the cwd
    local TITLE="\[\e]2;"$(basename "$(pwd)")"\a\]"
    PS1+="${TITLE}"

}

export HISTSIZE=100000
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export PATH="$PATH:$HOME/.local/bin:$HOME/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"
export PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"
export PATH="$PATH:$HOME/Documents/spack/bin"
export MANPATH="/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2022/texmf-dist/doc/info:$INFOPATH"
export EDITOR=nvim

# Properly export gnome-keyring stuff under sway
if [[ -n "${DESKTOP_SESSION}" ]]; then
    eval $(gnome-keyring-daemon --start 2>/dev/null)
    export SSH_AUTH_SOCK
fi

up() { cd "$(eval printf '../'%.0s {1..$1})"; }
