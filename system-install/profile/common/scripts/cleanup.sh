#!/bin/bash

info 'Cleaning up'

mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share /mnt/redpen /mnt/blackpen

mkdir -p "$USER_HOME/Temp" "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Music" "$USER_HOME/Pictures" "$USER_HOME/Videos"
chown_user "$USER_HOME"/*

if [ "$DEV" != '1' ]; then
    info "Removing package cache"
    paru --noconfirm -Scc
fi
