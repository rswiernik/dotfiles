setopt prompt_subst
source $RZSH_HOME/plugins/async.zsh
source $RZSH_HOME/plugins/git-prompt.zsh


async_init
async_start_worker prompt_worker -n
async_register_callback prompt_worker git_info_callback


GIT_PROMPT=''
get_git_prompt() {
    echo "$GIT_PROMPT"
}


git_info_callback() {
    GIT_PROMPT="$3"
    zle && zle reset-prompt
}


async_git() {
    async_job prompt_worker git_super_status
}


add-zsh-hook precmd async_git


function prompt_char {
    echo '❯'
}


function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}


PROMPT='[%{$fg[yellow]%}%n@%m%{$reset_color%}] %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(virtualenv_info)$(prompt_char) '
RPROMPT='$(get_git_prompt)'
