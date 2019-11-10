#!/bin/bash
if [[ ! -d /opt/icecat ]]; then
    cd /tmp/ || exit
    get-extract https://mirrors.ocf.berkeley.edu/gnu/gnuzilla/60.7.0/icecat-60.7.0.en-US.gnulinux-x86_64.tar.bz2
    mv icecat /opt/
    ln -s /opt/icecat/icecat /usr/local/bin/icecat
    cd "$INITIALPATH" || exit
else
    echo 'Icecat is already installed'
fi