#!/bin/env sh

set -e

URL="https://github.com/cristianarbe/gnad/releases/download/v0.1/gnad"
BINARY_DIR="$HOME/.local/bin/"
BINARY_LOC="${BINARY_DIR}gnad"

if test ! -d "$BINARY_DIR"; then
  mkdir -p "$BINARY_DIR"
fi

printf "Downloading gnad... "
if ! wget "$URL" -O "$BINARY_LOC" > /dev/null 2>&1; then
  printf "Could not retrieve remote file.\\n"
  exit 1
fi

printf "Done\\n"

if ! chmod +x "$BINARY_LOC"; then
  printf "Could  not change permissions for %s\\n" "$BINARY_LOC"
fi

case "$PATH" in
*.local/bin*)
  printf "%s is already on the path. Great!\\n" "$BINARY_DIR"
  ;;
*)
  # shellcheck disable=SC2088
  printf "Adding %s to the path...  " "$BINARY_DIR"
  export PATH="$PATH:$BINARY_DIR"
  # shellcheck disable=SC2016
  printf 'export PATH="$PATH:$HOME/.local/bin"' >>~/.bashrc
  printf "Done"
  ;;
esac

if ! gnad version >/dev/null 2>&1; then
  printf "gnad not available. Unknown error.\\n"
  exit 1
fi

printf "All done. You can now use gnad.\\n"
