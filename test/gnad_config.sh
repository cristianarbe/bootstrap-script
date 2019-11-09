#!/bin/bash
export install=(
    filezilla
    firefox
    gnome-disk-utility
    gparted
    highlight
    keepassxc
    p7zip
    pandoc
    qdirstat
    redshift
    shellcheck
    thunderbird
    tmux
    torbrowser-launcher
    vim
    vlc
    zathura
)

export uninstall=(
    akregator
    ark
    asunder
    calligra*
    catfish
    claws-mail
    clipit
    dolphin
    evince
    falkon
    firewall-config
    florence
    galculator
    geany
    gigolo
    gimp
    gnome-control-center
    golang
    gpicview
    gwenview
    juk
    kamoso
    kcalc
    kcharselect
    kfind
    kget
    kgpg
    khelpcenter
    kinfocenter
    kmag
    kmahjongg
    kmail
    kmines
    kmousetool
    kmouth
    kolourpaint
    konqueror
    kontact
    konversation
    korganizer
    kpat
    krdc
    krfb
    krusader
    ksysguard
    ktorrent
    kwalletmanager
    libreoffice
    lxmusic
    lxtask
    lxterminal
    midori
    mousepad
    okular
    orage
    osmo
    parole
    pcmanfm
    pidgin
    pragha
    qbittorrent
    ristretto
    seahorse
    snapd
    spectacle
    sylpheed
    terminology
    thunar
    transmission
    xarchiver
    xfburn
    xfce4-clipman-plugin
    xfce4-cpugraph-plugin
    xfce4-dict
    xfce4-mailwatch-plugin
    xfce4-taskmanager
    xfce4-terminal
    xfce4-weather-plugin
    xfce4-whiskermenu-plugin
    xfdashboard
    xpad
    xscreensaver*
    yelp
    youtube-dl
)

readonly REPO="https://github.com/cristianarbe/dotfiles.git"

extra_packages(){
    FILE="$*"
    SCRIPTPATH="${FILE%/*}"
    for file in "${SCRIPTPATH}"/extra/*.sh; do
        # shellcheck disable=SC1090
        source "$file"
    done
}