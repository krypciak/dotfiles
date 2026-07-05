#!/bin/bash
if [ $# -eq 0 ]; then
    . ~/.config/at-login.sh
    exec start-hyprland >~/.config/hypr/log.txt 2>&1
else
    hyprland "$@"
fi
