#!/bin/bash -x

# TODO:
# Check if operations are already done before asking
# Use dialogs

set -e
source config
mkdir -p /var/log/bootstrap
readonly LOG="/var/log/bootstrap/bootstrap.log"
{ echo ""; date; echo ""; } 

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

readonly REPO="https://github.com/cristianarbe/dotfiles.git"

dot_files(){
  if [[ -f /home/"${SUDO_USER}"/README.md ]]; then
    echo "Dot files are already set"
  else
    echo "Setting up dot files..."
    [[ -d /tmp/dotfiles ]] && rm -rfv /tmp/dotfiles 
    su - "${SUDO_USER}" -c "rm -rf dotfiles"
    su - "${SUDO_USER}" -c "git clone $REPO" 
    su - "${SUDO_USER}" -c "mv dotfiles/.git/ ../"
    su - "${SUDO_USER}" -c "git reset --hard"
    su - "${SUDO_USER}" -c "xrdb /home/${SUDO_USER}/.Xresources"
  fi
}

install_dnf(){
  echo "Uninstalling dnf packages..."
  # shellcheck disable=SC2068
  dnf remove ${uninstall[@]} -y --skip-broken

  echo "Installing dnf packages..."
  # shellcheck disable=SC2068
  dnf install ${install[@]} -y --skip-broken

  su - "${SUDO_USER}" -c systemctl --user start syncthing
  su - "${SUDO_USER}" -c systemctl --user enable syncthing

}

extra_packages(){

  # Install vim plug
    su - "${SUDO_USER}" -c "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

 # Install duplicati
 if [[ -f  /bin/duplicati ]]; then
   echo "Duplicaty is already installed"
 else
   cd /tmp/ || exit
   wget 'https://updates.duplicati.com/beta/duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm' 
   dnf install ./duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm -y 
 fi

 # Install VLC
 if [[ -f /bin/vlc ]]; then
   echo "VLC is already installed"
 else
   dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y 
   dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y 
   dnf install vlc -y 
   su - "${SUDO_USER}" -c "mkdir /home/${SUDO_USER}/.cache/vlc/ -p"
 fi

 # Install duplicati
 if [[ -f  /bin/duplicati ]]; then
   echo "Duplicaty is already installed"
 else
   dnf install https://github.com/duplicati/duplicati/releases/download/v2.0.4.23-2.0.4.23_beta_2019-07-14/duplicati-2.0.4.23-2.0.4.23_beta_20190714.noarch.rpm -y
 fi

 # setup openvpn

 cd /etc/openvpn
 wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
 unzip openvpn.zip

}

function main(){

  echo ""
  echo "1. Dot files install"
  echo "===================="
  echo ""
  echo "This installs my personal dot files"
  read -rp "Do you want to proceed? [y/N]: " response
  if [[ $response == "y" ]]; then
    dot_files
  fi

  echo ""
  echo "2. Packages install"
  echo "==================="
  echo ""
  echo "This installs the packages that I use"
  read -rp "Do you want to proceed? [y/N]: " response
  if [[ $response == "y" ]]; then
    install_dnf
  fi

  echo ""
  echo "3. Extra packages"
  echo "================="
  echo ""
  echo "This installs packages that are not in dnf. This includes duplicati, \
VLC and vim plug"

  read -rp "Do you want to proceed? [y/N]: " response
  if [[ $response == "y" ]]; then
    extra_packages
  fi

  echo ""
  echo "4. Installation finished"
  echo "========================"
  echo ""
  echo "This step will reboot the system"
  read -rp "Do you want to proceed? [y/N]: " response
  if [[ $response = "y" ]]; then
    reboot
  else
    echo "All done!"
  fi
}

main
