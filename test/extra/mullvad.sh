#!/bin/bash
if ! dpkg -l mullvad-vpn &> /dev/null; then
    wget https://mullvad.net/media/app/MullvadVPN-2019.9_amd64.deb
    apt install ./MullvadVPN-2019.9_amd64.deb
else
    echo 'Mullvad is already installed.'
fi