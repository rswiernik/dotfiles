RZSH_HOME="$HOME/.config/rzsh"
source "$RZSH_HOME/rzsh.zsh"

# Get your rustlang on
source $HOME/.cargo/env

# Get your golang on
export PATH="$PATH:$(go env GOPATH)/bin"

export EDITOR='vim'

alias cgrep="grep --color=always"
alias colorgrep="cgrep"
alias dush="du -sh"
alias lsdu="dush ./*"

function findhere() {
    find ./ -name "*$@*"
}

function searchzshhistory() {
    grep -rn "$@" ~/.zsh_history
}
