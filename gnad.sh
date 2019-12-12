#!/bin/env sh
#
# Manage bootstrap scripts

readonly PROFILE_NAME="$(printf '%s' "$2" | tr '/' '-')"
readonly CONFIG_PATH="${HOME}/.config/gnad/profiles"
readonly PROFILE_PATH="${CONFIG_PATH}/${PROFILE_NAME}"

#######################################
# Downloads a bootstrap script on the
# profile folder
# Globals:
#   PROFILE_PATH
# Arguments:
#   Github repository
# Returns:
#   Status
#######################################
get(){
  mkdir -pv "${PROFILE_PATH}"
  git clone --depth 1 "https://github.com/${1}" "${PROFILE_PATH}"
  if [ -d "${PROFILE_PATH}"/.git ]; then
    echo "Profile installed"
    return 0
  else
    echo "Profile installation failed." >&2
    return 1
  fi
}

#######################################
# Runs a bootstrap script
# Globals:
#   PROFILE_PATH
# Arguments:
#   None
# Returns:
#   Status
#######################################
run(){
  chmod +x "${PROFILE_PATH}/install"
  if "${PROFILE_PATH}"/install; then
    echo "Script ran successfully"
    return 0
  else
    echo "Script failed." >&2
    return 1
  fi

}

list(){
  ls -1 "${HOME}/.config/gnad/profiles/"
}

remove(){
  rm -rf "${PROFILE_PATH}"
}

#######################################
# Updates all the bootstrap scripts
# Globals:
#   CONFIG_PATH
# Arguments:
#   None
# Returns:
#   None
#######################################
update(){
  printf "This will override any change you have made to the profile, do you \n"
  printf "want to continue? (y/N): "
  read -r answer

  [ "${answer}" != "y" ] && return

  for profile in "${CONFIG_PATH}"/*; do
    cd "${CONFIG_PATH}/${profile}" || exit
    git pull
  done

  printf "Updated all scripts. Do 'gnad run [script]' if you want to \n"
  printf "upgrade. Note that this will override all your settings!"
}

help(){
  echo "gnad"
  echo "Usage: gnad command [profile]"
  echo ""
  echo "gnad is a bootstrap scripts manager"
  echo ""
  echo "Commands:"
  echo "  get - get script from github"
  echo "  run- run a script"
  echo "  list - list installed scripts"
  echo "  remove - remove a script"
  echo "  update - update all the scripts"
  echo "  help - shows this help"
}

main(){
  case "$@" in
    get|run|list|remove|update|help)
      "$@"
      ;;
    *)
      help
      ;;
  esac
}

main "$@"
