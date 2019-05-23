#!/bin/bash
# TODO: Setting return errors


function ask_reboot(){
		echo "##### Finished"
		echo "Do you want to reboot now? (y/N)"
		read -r reboot_option
		if [[ $reboot_option = "y" ]]; then
				reboot
		else
				echo "All done!"
		fi
}

function check_root(){
		if [[ $EUID -ne 0 ]]; then
				echo "This script must be run as root"
				exit 1
		fi
}

function main(){
		printf "\n### Initiating\n"
readonly REPO="https://github.com/cristianarbe/dot-files.git"

if [[ -f /home/${SUDO_USER}/README.md ]]; then
		echo "Dot files are already set"
else
		echo "###### Setting up dot files"
		cd  /tmp/ || exit
		git clone "$REPO"
		cd dot-files || exit
		shopt -s dotglob
		mv /tmp/dot-files/* "/home/${SUDO_USER}/"
fi
mkdir -p /usr/share/themes/noborders/xfwm4/
touch /usr/share/themes/noborders/xfwm4/themerc
MEGASYNC_URL="https://mega.nz/linux/MEGAsync/Fedora_29/x86_64/megasync-Fedora_29.x86_64.rpm"

cd /tmp/ || exit
if [[ -f /bin/megasync ]]; then
		echo "MEGASync is already installed"
else
		echo "##### Installing MEGASync"
		wget $MEGASYNC_URL
		local file
		file=$(find . -name "megasync-Fedora*")
		dnf install "$file"
fi
#!/bin/bash
echo "###### Installing dnf packages"
install_packages=$(cat "config/install_packages.txt")
dnf install "$install_packages" -y

uninstall_packages=$(cat "config/uninstall_packages.txt")
dnf remove "$uninstall_packages" -y

dnf upgrade -y
readonly pia_exists=$(find /etc/openvpn/ -name "pia*" | wc -l)
if [[ $pia_exists -eq 0 ]]; then
		cd /tmp/ || exit
		echo "###### Installing PIA"
		wget "$PIA_URL"
		bash pia-nm.sh
else
		echo "PIA is already installed"
fi
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		ask_reboot
}

main
