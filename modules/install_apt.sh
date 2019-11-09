#!/bin/bash

install_apt(){
    echo 'Updating cache...'
    apt update
    echo "Installing apt packages..."
    # shellcheck disable=SC2154
    # shellcheck disable=SC2068
    apt install ${install[@]} -y
    
    echo "Uninstalling apt packages..."
    # shellcheck disable=SC2154
    # shellcheck disable=SC2068
    apt remove ${uninstall[@]}

    echo 'Autoremoving...'
    apt autoremove -y
}
