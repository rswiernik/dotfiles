RZSH_HOME="$HOME/.config/rzsh"
source "$RZSH_HOME/rzsh.zsh"

# Get your rustlang on
source $HOME/.cargo/env

# Get your golang on
export PATH="$PATH:$(go env GOPATH)/bin"

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
