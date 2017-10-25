## History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt append_history

setopt hist_expire_dups_first
setopt hist_ignore_dups

setopt inc_append_history
setopt share_history

bindkey '^R' history-incremental-search-backward

