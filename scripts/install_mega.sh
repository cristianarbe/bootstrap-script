
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
