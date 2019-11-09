#!/bin/bash

ask(){
    read -rp "$1" response
    if [[ $response == "y" ]]; then
        "$2"
    fi
}