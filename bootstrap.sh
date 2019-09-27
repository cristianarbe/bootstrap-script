#!/bin/bash -x

set -e
source config
mkdir -p /var/log/bootstrap
readonly LOG="/var/log/bootstrap/bootstrap.log"
{ echo ""; date; echo ""; } >> $LOG

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

readonly REPO="https://github.com/cristianarbe/dot-files.git"

dot_files(){
  if [[ -f /home/${SUDO_USER}/README.md ]]; then
    echo "Dot files are already set"
  else
    echo "Setting up dot files..."
    [[ -d /tmp/dot-files ]] && rm -rfv /tmp/dot-files >> $LOG
    cd  /tmp/ || exit
    git clone "$REPO" >> $LOG
    cd dot-files || exit
    shopt -s dotglob
    cp -rv /tmp/dot-files/* "/home/${SUDO_USER}/" >> $LOG
  fi
}

install_dnf(){
  echo "Installing dnf packages..."
  # shellcheck disable=SC2068
  dnf install ${install[@]} -y --skip-broken

  echo "Uninstalling dnf packages..."
  # shellcheck disable=SC2068
  dnf remove ${uninstall[@]} -y --skip-broken
}

extra_packages(){

  # Install vim plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOG

 # Install duplicati
 if [[ -f  /bin/duplicati ]]; then
   echo "Duplicaty is already installed"
 else
   cd /tmp/ || exit
   wget 'https://updates.duplicati.com/beta/duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm' >> $LOG
   dnf install ./duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm -y >> $LOG
 fi

 # Install VLC
 if [[ -f /bin/vlc ]]; then
   echo "VLC is already installed"
 else
   dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y >> $LOG
   dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y >> $LOG
   dnf install vlc -y >> $LOG
 fi
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
  echo "This installs packages that are not in dnf. This includes PIA, \
    and vim plug"

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
