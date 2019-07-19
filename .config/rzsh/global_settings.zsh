setopt nonomatch
setopt nobeep

bindkey -v

R_MAX_PROMPT_LEN=20

PATH="$PATH:/home/rswiernik/.local/bin"

[[ -n $RZSH_THEME ]] || RZSH_THEME="default"

R_ON_MAC=false
[[ "$(uname)" = "Darwin" ]] && R_ON_MAC=true
export $R_ON_MAC

# autoload zkbd
# function zkbd_file() {
#     [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
#     [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
#     return 1
# }
# 
# [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
# keyfile=$(zkbd_file)
# ret=$?
# if [[ ${ret} -ne 0 ]]; then
#     zkbd
#     keyfile=$(zkbd_file)
#     ret=$?
# fi
# if [[ ${ret} -eq 0 ]] ; then
#     source "${keyfile}"
# else
#     printf 'Failed to setup keys using zkbd.\n'
# fi
# unfunction zkbd_file; unset keyfile ret
# 
# # setup key accordingly
# [[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
# [[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
# [[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
# [[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
# [[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
# [[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
# [[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
# [[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
# [[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char
# 
# ## Key setup taken from http://zshwiki.org/home/zle/bindkeys
# typeset -g -A key
# 
# key[Home]="$terminfo[khome]"
# key[End]="$terminfo[kend]"
# key[Insert]="$terminfo[kich1]"
# key[Backspace]="$terminfo[kbs]"
# key[Delete]="$terminfo[kdch1]"
# key[Up]="$terminfo[kcuu1]"
# key[Down]="$terminfo[kcud1]"
# key[Left]="$terminfo[kcub1]"
# key[Right]="$terminfo[kcuf1]"
# key[PageUp]="$terminfo[kpp]"
# key[PageDown]="$terminfo[knp]"
# 
# # setup key accordingly
# [[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
# [[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
# [[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
# [[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
# [[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
# [[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
# [[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
# [[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
# [[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char
# 
# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
# if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
#     function zle-line-init () {
#         echoti smkx
#     }
#     function zle-line-finish () {
#         echoti rmkx
#     }
#     zle -N zle-line-init
#     zle -N zle-line-finish
# fi
