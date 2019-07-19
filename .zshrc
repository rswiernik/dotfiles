ZSH_LOCAL="$HOME/.zshrc.local"
RZSH_HOME="$HOME/.config/rzsh"
source "$RZSH_HOME/rzsh.zsh"

[[ -f "$ZSH_LOCAL" ]] && source $ZSH_LOCAL

if [[ -d $HOME/.cargo ]]; then
    # Get your rustlang on
    source $HOME/.cargo/env
fi

if [[ -n "$(/usr/bin/which go &>/dev/null)" ]]; then
    # Get your golang on
    export PATH="$PATH:$(go env GOPATH)/bin"
fi

export EDITOR='vim'

# ------
RZSH_LOCAL_CONF=$HOME/.rzsh_local
[[ -f $RZSH_LOCAL_CONF ]] && source $RZSH_LOCAL_CONF

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
[[ $R_ON_MAC ]] && ls_color_option="-G"
alias ls="ls ${ls_color_option}"
