#!/usr/bin/env bash
#
# Sets up the themes

readonly DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
readonly USER_HOME="/home/${SUDO_USER}"
readonly XFCE_CONFIG="$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml"

#######################################
# Installs the theme
# Globals:
#   USER_HOME
#   THEME_URL
# Arguments:
#   None
# Returns:
#   None
#######################################
install_theme() {
    common::create_and_go "$USER_HOME/.themes" -p
    common::get_extract "$THEME_URL"
    bash "$USER_HOME/.themes/vimix-gtk-themes/Install"
    common::user_do \
        common::xfupdate "theme" "vimix-light-doder"
    sed -i \
        's/<property name="theme" type="string" value=".*"\/>/<property name="theme" type="string" value="vimix-light-doder"\/>/g' \
        "$XFCE_CONFIG"/xfwm4.xml
}

#######################################
# Installs the icons
# Globals:
#   USER_HOME
#   ICONS_URL
# Arguments:
#   None
# Returns:
#   None
#######################################
install_icons() {
    common::create_and_go "$USER_HOME/.icons" -p
    common::get_extract "$ICONS_URL"
    bash "$USER_HOME/.icons/vimix-icon-theme-master/install.sh"
    common::xfupdate "icon-theme" "Vimix-Paper"
}

#######################################
# Installs the wallpaper
# Globals:
#   USER_HOME
#   WALLPAPER_URL
# Arguments:
#   None
# Returns:
#   None
#######################################
install_wallpaper() {
    common::create_and_go "$USER_HOME/Pictures/"
    wget "$WALLPAPER_URL"
    # shellcheck disable=SC2016
    common::xf_update wallpaper "$USER_HOME/Pictures/banner.jpg"
}

#######################################
# Installs the fonts
# Globals:
#   USER_HOME
#   FONT_URL
# Arguments:
#   None
# Returns:
#   None
#######################################
install_font() {
    common::create_and_go "$USER_HOME/.fonts/"
    common::get_extract "$FONT_URL"
    common::xf_update font "Clear Sans 12"
    sed -i \
        's/<property name="title_font" type="string" value=".*"\/>/<property name="title_font" type="string" value="Clear Sans 12"\/>/g' \
        "$XFCE_CONFIG"/xfwm4.xml
}

#######################################
# Install all the elements of the
# appearance
# Globals:
#   USER_HOME
#   SUDO_USER
# Arguments:
#   None
# Returns:
#   None
#######################################
setup_appearance() {

    pkill xfconfd

    \cp -rf .config "$USER_HOME"/
    for action in theme icons wallpaper font; do
        install_$action
    done
    common::xf_update cursor-theme Breeze

    # Make user own directories
    for folder in icons themes; do
        chown -R "${SUDO_USER}:${SUDO_USER}" "$USER_HOME/.$folder"
    done
}
