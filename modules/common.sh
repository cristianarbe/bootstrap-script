#!/bin/bash

ask(){
    read -rp "$1" response
    if [[ $response == "y" ]]; then
        eval "$2"
    fi
}

removeif(){
    if [[ -f "$1" ]]; then
        rm "$1"
    fi
}

goto(){
    mkdir "$1" -p
    cd "$1" || exit
}

extract(){
    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar e "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7za e "$1"       ;;
        *.tar.xz)    tar xf "$1"      ;;
        *)           echo "'$1' cannot be extracted" ;;
    esac
}

get_extract(){
    url="$1"
    if [[ "$2" == "" ]]; then
        extension="${url##*.}"
    else
        extension="$2"
    fi
    wget "$url" -O  downloaded."$extension"
    extract downloaded."$extension"
}

force_copy(){
    removeif "$2"
    cp "$1" "$2"
}
