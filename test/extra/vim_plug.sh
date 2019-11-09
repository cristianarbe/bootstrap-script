#!/bin/bash
if [[ -f /home/${SUDO_USER}/.vim/autoload/plug.vim ]]; then
    su - "${SUDO_USER}" -c "curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi