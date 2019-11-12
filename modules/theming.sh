#!/usr/bin/env bash
#
# Sets up the themes

readonly DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
readonly XFCE_CONFIG="$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
readonly USER_HOME="/home/${SUDO_USER}"

#######################################
# Installs the theme
# Globals:
#   USER_HOME
#   THEME_URL
#   SUDO_USER
# Arguments:
#   None
# Returns:
#   None
#######################################
install_theme() {
    common::create_and_go "$USER_HOME/.themes" -p
    common::get_extract "$THEME_URL"
    bash "$USER_HOME/.themes/vimix-gtk-themes/Install"
    su - "${SUDO_USER}" -c \
        'xfconf-query -c xfwm4 -p /general/theme -s "vimix-light-doder"'
    sed -i \
        's/<property name="theme" type="string" value=".*"\/>/<property name="theme" type="string" value="vimix-light-doder"\/>/g' \
        ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
}

#######################################
# Installs the icons
# Globals:
#   USER_HOME
#   ICONS_URL
#   SUDO_USER
# Arguments:
#   None
# Returns:
#   None
#######################################
install_icons() {
    common::create_and_go "$USER_HOME/.icons" -p
    common::get_extract "$ICONS_URL"
    bash "$USER_HOME/.icons/vimix-icon-theme-master/install.sh"
    su - "${SUDO_USER}" -c \
        "xfconf-query -c xsettings -p /Net/IconThemeName -s 'Vimix-Paper'"
}

#######################################
# Installs the cursor theme
# Globals:
#   SUDO_USER
# Arguments:
#   None
# Returns:
#   None
#######################################
install_cursor_theme() {
    su - "${SUDO_USER}" -c \
        'xfconf-query -c xsettings -p /Gtk/CursorThemeName -s Breeze'
}

#######################################
# Installs the wallpaper
# Globals:
#   SUDO_USER
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
    su - "${SUDO_USER}" -c \
        'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$USER_HOME/Pictures/banner.jpg"'
}

#######################################
# Installs the fonts
# Globals:
#   USER_HOME
#   FONT_URL
#   SUDO_USER
# Arguments:
#   None
# Returns:
#   None
#######################################
install_font() {
    common::create_and_go "$USER_HOME/.fonts/"
    common::get_extract "$FONT_URL"
    su - "${SUDO_USER}" -c \
        'xfconf-query -c xsettings -p /Gtk/FontName -s "Clear Sans 12"'
    sed -i \
        's/<property name="title_font" type="string" value=".*"\/>/<property name="title_font" type="string" value="Clear Sans 12"\/>/g' \
        ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
}

setup_appearance() {

    pkill xfconfd

    install_theme
    install_icons
    install_cursor
    install_wallpaper
    install_font
    \cp -rf .config "$USER_HOME"/

    # Make user own directories
    for folder in icons themes; do
        chown -R "${SUDO_USER}:${SUDO_USER}" "$USER_HOME/.$folder"
    done

    # Restart xfce
    xfce4-panel -r
    /usr/lib64/xfce4/xfconf/xfconfd &>/dev/null &
}
