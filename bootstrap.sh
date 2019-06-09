#!/bin/bash -x

set -e
mkdir -p /var/log/bootstrap
readonly LOG="/var/log/bootstrap/bootstrap.log"
{ echo ""; date; echo ""; } >> $LOG

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

readonly REPO="https://github.com/cristianarbe/dot-files.git"
readonly PIA_EXISTS=$(find /etc/openvpn/ -name "pia*" | wc -l)
readonly PIA_URL="https://www.privateinternetaccess.com/installer/pia-nm.sh"
readonly MEGASYNC_URL="https://mega.nz/linux/MEGAsync/Fedora_30/x86_64/megasync-Fedora_30.x86_64.rpm"

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
    mv -v /tmp/dot-files/* "/home/${SUDO_USER}/" >> $LOG
  fi
  mkdir -vp /usr/share/themes/noborders/xfwm4/ >> $LOG
  touch /usr/share/themes/noborders/xfwm4/themerc >> $LOG
}

install_dnf(){
  echo "Installing dnf packages..."
  install_packages=$(cat config/install_packages.txt)
  # shellcheck disable=SC2086
  dnf install $install_packages -y --skip-broken >> $LOG

  echo "Uninstalling dnf packages..."
  uninstall_packages=$(cat config/uninstall_packages.txt)
  # shellcheck disable=SC2086
  dnf remove $uninstall_packages -y --skip-broken >> $LOG

  echo "Upgrading..."
  dnf upgrade -y >> $LOG
}

extra_packages(){
  # Install PIA
  if [[ $PIA_EXISTS -eq 0 ]]; then
    cd /tmp/ || exit
    echo "Installing PIA..."
    wget "$PIA_URL" >> $LOG
    bash pia-nm.sh
  else
    echo "PIA is already installed"
  fi

  # Install vim plug
  if [[ -f ~/.vim/autoload/plug.vim ]]; then
    echo "Vim plug is already installed"
  else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOG
  fi

  # Install megasync
  cd /tmp/ || exit
  if [[ -f /bin/megasync ]]; then
    echo "MEGASync is already installed"
  else
    echo "Installing MEGASync..."
    wget $MEGASYNC_URL >> $LOG
    local file
    file=$(find . -name "megasync-Fedora*")
    dnf install "$file" -y
  fi

  # Install waldorf theme
  if [[ -d /usr/share/themes/waldorf1314 ]]; then
    echo "Waldorf theme is already installed"
  else
		  { wget 'https://dl.opendesktop.org/api/files/download/id/1460968153/s/630a5ea1c93c05cefad04f3c4fd89059f9ef6112b2d50f27ed217a6a9464a439c2f91480327da21eb5c9954f4d4a1c3172d43510103b96d00752b60b42197ac4/t/1560079934/lt/download/162986-waldorf1314.tar.xz';
    tar xf 162986-waldorf1314.tar.xz;
    cp waldorf1314 /usr/share/themes/ -vri; } >> $LOG
  fi

 # Install duplicati
 if [[ -f  /bin/duplicati ]]; then
   echo "Duplicaty is already installed"
 else
   cd /tmp/ || exit
   wget 'https://updates.duplicati.com/beta/duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm' >> $LOG
   dnf install ./duplicati-2.0.4.5-2.0.4.5_beta_20181128.noarch.rpm -y
 fi

 # Install VLC
 if [[ -f /bin/vlc ]]; then
   echo "VLC is already installed"
 else
   dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
   dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
   dnf install vlc -y
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
    MegaSync and vim plug"

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
