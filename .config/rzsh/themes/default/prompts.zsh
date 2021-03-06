# My prompt setup! This has been set up for me, but could be modified easily.
# You get ssh detection for showing the machine name in the prompt, a pleasant pwd display and async
# git information in the reverse prompt. This information is cached, and works well in most cases,
# however with any cached information, has a tendency for being stale when doing certain operations.
# (eg. changing branches) Here's an example of what this looks like in practice:
#
# [rswiernik-mbp] ..memcache/deployments❯                                                (master|✔)
#

setopt prompt_subst
source $RZSH_HOME/plugins/async.zsh

async_init

GIT_PROMPT=''
GIT_PLACEHOLDER="(...)"

get_git_prompt() {
    echo -n "$GIT_PROMPT"
}

git_info_callback() {
    if [[ $3 =~ "[0-9]\.[0-9]\+" ]]; then
        GIT_PROMPT=""
    else
        GIT_PROMPT="$3"
    fi
    zle && zle reset-prompt
    rm $WORKER_TEMP_STUB
}

git_super_status() {
    GIT_PROMPT="$(python3 ${RZSH_HOME}/plugins/gitstatus.py $1 --zsh-escape)"
    echo ${GIT_PROMPT}
}

# This is where we actually do the work
git_precommand() {
    # If in a git directory, show the pending git prompt
    if [[ -d .git ]] || [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) = "true" ]]; then
        if [[ -z ${GIT_PROMPT} ]]; then
            GIT_PROMPT="${GIT_PLACEHOLDER}"
        else;
            GIT_PROMPT="?${GIT_PROMPT}"
        fi

        if [[ ! -f $WORKER_TEMP_STUB ]]; then
            touch $WORKER_TEMP_STUB
            async_job prompt_worker git_super_status "$(pwd)"
        fi
    # If not, don't show anything
    else;
        GIT_PROMPT=""
    fi
}

### Remaining ZSH prompt setup
function prompt_char {
    echo -n '❯'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo -n '('`basename $VIRTUAL_ENV`') '
}

function trimmed_pwd {
    CWD="%{$fg_bold[green]%}"
    GIT_REPO=""
    # If we're in a git directory, replace the start of the wd with nothing
    GIT_WD="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -n $GIT_WD ]]; then
        GIT_REPO="%{$fg[yellow]%}$(basename ${GIT_WD} 2>/dev/null)%{$fg_bold[green]%} "
        WD="${PWD/#$GIT_WD/}"
        WD="${WD: 1}"
    else
        WD="${PWD/#$HOME/~}"
    fi

    if [[ $(echo "${#WD}") -gt ${R_MAX_PROMPT_LEN} ]]; then
        WD="..${WD: -${R_MAX_PROMPT_LEN}}"
    fi

    CWD="${CWD}${GIT_REPO}${WD}%{$reset_color%}"
    echo -n $CWD
}

CACHED_HOST_COLOR=""
function get_user_machine {
    sumfunc="md5sum"
    [[ -n $R_ON_MAC ]] && sumfunc="md5"
    if [[ -z $CACHED_HOST_COLOR ]]; then
        colors=('cyan' 'yellow' 'blue' 'magenta' 'red' 'white')
        host_num_hash=$(echo $HOSTNAME | $sumfunc | sed 's/[a-fA-F]//g' | head -c 5)
        CACHED_HOST_COLOR="$colors[$((${host_num_hash} % ${#colors[@]}))]"
    fi

    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]] || [[ -n $SSH_AUTH_SOCK ]]; then
        # echo "%n@%m"
        echo -n "[%{$fg[${CACHED_HOST_COLOR}]%}%m%{$reset_color%}]"
    fi
}

### Setup for async git prompt
# TODO: Move git prompt wrappers into theme possibly? Also collapse git prompt tools to smaller lib
# TODO: Figure out if this worker stub belongs here (Push down into async or up to higher level)
WORKER_TEMP_STUB="${HOME}/._rzsh_prompt_worker_stub_$(od -vAn -N4 -tu8 < /dev/urandom | tr -d "[:space:]")"
# This cleans up the worker stub file on shell exit. This is useful when you exit before a worker returns
trap "if [[ -f $WORKER_TEMP_STUB ]]; then rm ${WORKER_TEMP_STUB}; fi" EXIT

async_start_worker prompt_worker -n
async_register_callback prompt_worker git_info_callback
# Register the hook to be run precommand
add-zsh-hook precmd git_precommand

ZLE_RPROMPT_INDENT=0

PROMPT='$(get_user_machine) $(trimmed_pwd)$(virtualenv_info)$(prompt_char) '
RPROMPT='$(get_git_prompt)'

