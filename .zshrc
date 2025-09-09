source "${HOME}/.config/rzsh/rzsh.zsh"

if [[ -d $HOME/.cargo ]]; then
    # Get your rustlang on
    source $HOME/.cargo/env
fi

if [[ -n "$(/usr/bin/which go &>/dev/null)" ]]; then
    # Get your golang on
    export PATH="$PATH:$(go env GOPATH)/bin"
fi

export EDITOR='vim'


mount_location="/home/$USERNAME/tmp/vardon"
# Functions for me!
function vardonmount() {
    if [[ ! -d $mount_location ]]; then
        mkdir -p $mount_location
    fi
    sudo mount -t cifs -o username=$USERNAME //vardon/media $mount_location
}

function vardonumount() {
    umount $mount_location
}


ls_color_option="--color=auto"
[[ -n $R_ON_MAC ]] && ls_color_option="-G"
alias ls="ls ${ls_color_option}"


# ------
# TODO: move this into rzsh configs
RZSH_LOCAL_CONF=$HOME/.rzsh_local
[[ -f $RZSH_LOCAL_CONF ]] && source $RZSH_LOCAL_CONF

# Import local machine sepecfic configs
ZSH_LOCAL="$HOME/.zshrc.local"
[[ -f "$ZSH_LOCAL" ]] && source $ZSH_LOCAL

# Pyenv Config
if [[ $(which pyenv &> /dev/null) ]] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi


function fix_grpc_packages {
    pip install --no-binary :all: grpcio --ignore-installed && \
    pip install --no-binary :all: grpcio-tools --ignore-installed
}

function close_branch {
    f_branch="$(git branch --show-current)"
    git checkout main
    git branch -D ${f_branch}
}

function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}

function kubectlgetallreplicas {
    kubectl get replicasets -A | awk '{if ($5 ~/0/) next; printf("%65s %4d %4d %4d\n", $2, $3, $4, $5) }'
}

source <(kubectl completion zsh)
