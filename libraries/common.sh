#!/usr/bin/env bash
#
# Definition of functions

#######################################
# Creates a directory and cd's in
# Globals:
#   None
# Arguments:
#   Directory path
# Returns:
#   None
#######################################
common::create_and_go() {
    #shellcheck disable=SC2164
    mkdir "$1" -p && cd "$1"
}

#######################################
# Universal file extractor
# Globals:
#   None
# Arguments:
#   File path
# Returns:
#   None
#######################################
common::extract() {
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar e "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.7z) 7za e "$1" ;;
    *.tar.xz) tar xf "$1" ;;
    *) common::err "'$1' cannot be extracted" ;;
    esac
}

#######################################
# Downloads and extracts a compressed
# file
# Globals:
#   None
# Arguments:
#   File path
# Returns:
#   None
#######################################
common::get_extract() {
    local url
    url="$1"
    [[ -z "$2" ]] && extension="${url##*.}" || extension="$2"
    wget "$url" -O downloaded."$extension"
    common::extract downloaded."$extension"
}

#######################################
# Throws an error to stderr
# file
# Globals:
#   None
# Arguments:
#   Error message
# Returns:
#   Error message through stderr
#######################################
# shellcheck disable=SC2145
common::err() { echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2; }

#######################################
# Checks if the remote file exists
# file
# Globals:
#   None
# Arguments:
#   Url
# Returns:
#   True or false
#######################################
url_exists() {
    local response
    response="$(curl -s "$1")"
    [[ $response == *404* ]] && echo false || echo true
}

#######################################
# Updates an xfce property
# Globals:
#   SUDO_USER
# Arguments:
#   Property
#   Value
# Returns:
#   None
#######################################
common::xf_update() {

    case $1 in
    theme) channel="-c xfwm4 -p /general/theme -s" ;;
    icon-theme) channel="-c xsettings -p /Net/IconThemeName -s" ;;
    cursor-theme) channel="-c xsettings -p /Gtk/CursorThemeName -s" ;;
    wallpaper) channel="-c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s" ;;
    font) channel="-c xsettings -p /Gtk/FontName -s" ;;
    *) err "XFCE property does not exist" ;;
    esac

    su - "${SUDO_USER}" -c "xfconf-query $channel $2"

}
