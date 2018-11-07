#!/bin/bash

dryrun=''
no_backup=''
copy_dest="$HOME"

for opt in "$@"; do
    case $opt in
        -d|--dryrun|--dry-run)
            echo "Dryrun mode active..."
            dryrun=1
            shift
            ;;
        --no-backup)
            no_backup=1
            shift
            ;;
        /*|./*)
            echo "Taking $opt as install dir"
            copy_dest=$opt
            shift
            ;;
        \?)
            echo "Invalid options -$OPTARG" >&2
            exit 1
            ;;
    esac
done

default_backup_dir="${copy_dest}/.conf_backup"
confs='.tmux.conf .vimrc .zshrc'

if [[ ! $no_backup ]]; then
    if [[ $dryrun ]]; then
        echo "Dryrun, not creating backup dir..."
    elif [[ ! -d $default_backup_dir ]]; then
        echo "Creating backup config dir at $default_backup_dir"
        mkdir -p $default_backup_dir
    fi
    echo "Backing up configs to $default_backup_dir"
    for conf in $confs; do
        [[ ! $dryrun ]] && cp $copy_dest/$conf $default_backup_dir/
    done
else
    echo "Skipping backup due to --no-backup"
fi

echo "Copying in configs from git repo"
for conf in $confs; do
    [[ ! $dryrun ]] && cp ./$conf $copy_dest
done

echo "Copying in rzsh"
if [[ ! $dryrun ]]; then
    rzsh_home="$copy_dest/.config/rzsh"
    rm -rf $rzsh_home
    mkdir -p $rzsh_home
    cp -r ./.config/rzsh/* $rzsh_home
fi

if [[ ! $dryrun ]]; then
    read -p "Would you like to install Vundle? [y/n]" v_choice
    if [[ ${v_choice} = "y" ]]; then
        echo "Installing Vundle!"
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        vim +PluginInstall +qall
    else
        echo "Skipping Vundle install"
    fi
else
    echo "Skipping vundle install because of dryrun"
fi
