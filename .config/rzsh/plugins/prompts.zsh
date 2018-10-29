setopt prompt_subst
source $RZSH_HOME/plugins/async.zsh
source $RZSH_HOME/plugins/git-prompt.zsh

# This is way less brittle, but should probably be pulled out as a higher level config?
# TODO: Figure out if this belongs here
WORKER_TEMP_STUB="${HOME}/._rzsh_prompt_worker_stub_$(od -vAn -N4 -tu8 < /dev/urandom | tr -d "[:space:]")"
trap "if [[ -f $WORKER_TEMP_STUB ]]; then rm ${WORKER_TEMP_STUB}; fi" EXIT

async_init
async_start_worker prompt_worker -n
async_register_callback prompt_worker git_info_callback


GIT_PROMPT=''
get_git_prompt() {
    echo "$GIT_PROMPT"
}


git_info_callback() {
    if [[ $3 =~ "[0-9]\.[0-9]" ]]; then
        GIT_PROMPT=""
    else
        GIT_PROMPT="$3"
    fi
    zle && zle reset-prompt
    rm $WORKER_TEMP_STUB
}


async_git() {
    # If in a git directory, show the pending git prompt
    if [[ -d .git ]] || [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) = "true" ]]; then
        GIT_PROMPT="(...)"
    # If not, don't show anything
    else;
        GIT_PROMPT=""
    fi

    if [[ ! -f $WORKER_TEMP_STUB ]]; then
        touch $WORKER_TEMP_STUB
        async_job prompt_worker git_super_status "$(pwd)"
    fi
}


add-zsh-hook precmd async_git


function prompt_char {
    echo '❯'
}


function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function trimmed_pwd {
    CDW="${PWD/#$HOME/~}"
    if [[ $(echo "${#CDW}") -gt ${R_MAX_PROMPT_LEN} ]]; then
        CDW="..${CDW: -${R_MAX_PROMPT_LEN}}"
    fi
    echo $CDW
}

function get_user_machine {
    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
        # echo "%n@%m"
        echo "[%{$fg[yellow]%}%m%{$reset_color%}] "
    fi
}

# PROMPT='[%{$fg[yellow]%}$(get_user_machine)%{$reset_color%}] %{$fg_bold[green]%}$(trimmed_pwd)%{$reset_color%}$(virtualenv_info)$(prompt_char) '
PROMPT='$(get_user_machine)%{$fg_bold[green]%}$(trimmed_pwd)%{$reset_color%}$(virtualenv_info)$(prompt_char) '
RPROMPT='$(get_git_prompt)'
