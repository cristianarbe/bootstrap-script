#!/bin/bash

ask(){
    read -rp "$1" response
    if [[ $response == "y" ]]; then
        eval "$2"
    fi
}