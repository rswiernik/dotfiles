RZSH_HOME="$HOME/.config/rzsh"
source "$RZSH_HOME/rzsh.zsh"

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
