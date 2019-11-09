#!/bin/bash
cd /tmp/ || exit
wget https://mirrors.ocf.berkeley.edu/gnu/gnuzilla/60.7.0/icecat-60.7.0.en-US.gnulinux-x86_64.tar.bz2
tar xfj icecat-60.7.0.en-US.gnulinux-x86_64.tar.bz2
mv  icecat /opt/
ln -s /opt/icecat/icecat /usr/local/bin/icecat