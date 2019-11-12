#!/usr/bin/env bash
#
# Installs the apt packages

#######################################
# Installs the list of apt packages
# from the config file
# Globals:
#   INSTALL
#   UNINSTALL
# Arguments:
#   None
# Returns:
#   None
#######################################
install_apt_packages(){
    apt update
    # shellcheck disable=SC2154
    # shellcheck disable=SC2068
    apt install ${INSTALL[@]} -y
    
    # shellcheck disable=SC2154
    # shellcheck disable=SC2068
    apt remove ${UNINSTALL[@]} -y
    
    apt autoremove -y
}
