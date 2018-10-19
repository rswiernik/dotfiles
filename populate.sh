#!/bin/bash

dryrun=''
default_backup_dir="$HOME/.conf_backup"
confs='.tmux.conf .vimrc .zshrc'

while getopts "d" opt; do
    case $opt in
        d)
            echo "Dryrun mode active..."
            dryrun=1
            ;;
        \?)
            echo "Invalid options -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [[ ! -d $default_backup_dir ]]; then
    echo "Creating backup config dir at $default_backup_dir"
    mkdir -p $default_backup_dir
fi

echo "Backing up configs to $default_backup_dir"
for conf in $confs; do
    [[ ! $dryrun ]] && cp $HOME/$conf $default_backup_dir/
done

echo "Copying in configs from git repo"
for conf in $confs; do
    [[ ! $dryrun ]] && cp ./$conf $HOME
done

echo "Copying in rzsh"
if [[ ! $dryrun ]]; then
    rzsh_home="$HOME/.config/rzsh"
    rm -rf $rzsh_home
    mkdir -p $rzsh_home
    cp -r ./.config/rzsh/* $rzsh_home
fi

read -p "Would you like to install Vundle? [y/n]" v_choice
if [ ${v_choice} = "y" ]; then
    echo "Installing Vundle!"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo "Skipping Vundle install"
fi