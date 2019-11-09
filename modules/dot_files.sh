#!/bin/bash
dot_files(){
  if [[ -f /home/"${SUDO_USER}"/README.md ]]; then
    echo "Dot files are already set"
  else
    echo "Setting up dot files..."
    su - "${SUDO_USER}" -c "cd $HOME"
    su - "${SUDO_USER}" -c "rm -rf dotfiles"
    su - "${SUDO_USER}" -c "git clone $REPO"
    su - "${SUDO_USER}" -c "mv dotfiles/.git/ ./"
    su - "${SUDO_USER}" -c "git reset --hard"
  fi
}