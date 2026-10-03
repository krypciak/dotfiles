#!/bin/bash

info_garr 'Cleaning up'

info_barr "Creating home and /mnt directories"
mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share /mnt/redpen /mnt/blackpen

mkdir -p "$USER_HOME/Temp" "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Music" "$USER_HOME/Pictures" "$USER_HOME/Videos"
chown_user "$USER_HOME"/*

if [ "$TYPE" = 'iso' ] && [ "$DEV" != '1' ]; then
    info_barr "Removing package cache"
    paru --noconfirm -Scc
    rm -rf /var/cache/pacman/pkg /root/.cache/paru "$USER_HOME"/.cache/paru
fi

info_barr "Restoring sudo config"
if [ "$TYPE" = 'iso' ]; then
    cp "$DOTDIR"/system-install/profile/iso/root/etc/sudoers /etc/sudoers
else
    cp "$DOTDIR"/system-install/profile/common/root/etc/sudoers /etc/sudoers
fi
chmod -c 0440 /etc/sudoers

if [ "$TYPE" != 'iso' ]; then
    sed -i 's/#CheckSpace/CheckSpace/g' /etc/pacman.conf
fi

if [ "$ENCRYPT" = '1' ]; then
    touch /etc/encrypted
fi
