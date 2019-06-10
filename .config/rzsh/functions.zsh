# Common functions that are pretty helpful!

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

function searchbashhistory() {
    grep -rn "$@" ~/.bash_history
}
