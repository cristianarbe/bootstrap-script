#!/bin/sh
if ! dpkg -l mullvad-vpn; then
    wget https://mullvad.net/media/app/MullvadVPN-2019.9_amd64.deb
    apt install ./MullvadVPN-2019.9_amd64.deb
fi