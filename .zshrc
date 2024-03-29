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
