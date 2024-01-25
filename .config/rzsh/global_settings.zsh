setopt nonomatch
setopt nobeep

bindkey -v

R_MAX_PROMPT_LEN=20

PATH="$PATH:${HOME}/.local/bin"

[[ -n $RZSH_THEME ]] || RZSH_THEME="default"

R_ON_MAC=""
[[ "$(uname)" = "Darwin" ]] && R_ON_MAC=true
export R_ON_MAC

bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line
bindkey "\033[5~" up-line-or-history
bindkey "\033[6~" down-line-or-history
bindkey "\033[3~" delete-char

