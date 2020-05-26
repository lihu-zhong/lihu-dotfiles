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
alias sauce='source ~/.bash_profile'
alias sl='echo "lol u suck @ tiping"; ls'
alias vim='vimx'

function dg() {
    grep "$@" /usr/share/dict/words
}

function ls() {
    if [[ "${@: -1}" == "-t" ]]; then
        exa -lhbT --git
    else
        exa -lhbG "$@" --git
    fi
}

up() { cd "$(eval printf '../'%.0s {1..$1})"; }

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

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export PATH="$PATH:$HOME/.local/bin:$HOME/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

## Added by Master Password
source bashlib
mpw() {
    _copy() {
        if hash pbcopy 2>/dev/null; then
            pbcopy
        elif hash xclip 2>/dev/null; then
            xclip -selection clip
        else
            cat; echo 2>/dev/null
            return
        fi
        echo >&2 "Copied!"
    }

    # Empty the clipboard
    :| _copy 2>/dev/null

    # Ask for the user's name and password if not yet known.
    MPW_FULLNAME=${MPW_FULLNAME:-$(ask 'Your Full Name:')}

    # Start Master Password and copy the output.
    printf %s "$(MPW_FULLNAME=$MPW_FULLNAME command mpw "$@")" | _copy
}
export MPW_FULLNAME=Lihu\ Ben-Ezri-Ravin
