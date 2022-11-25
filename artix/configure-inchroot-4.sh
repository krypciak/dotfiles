#!/bin/bash

pri "Set password for user $USER1"
if [ "$USER_PASSWORD" != "" ]; then
    pri "${LBLUE}Automaticly filling password..."
    ( echo $USER_PASSWORD; echo $USER_PASSWORD; ) | passwd $USER1
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd $USER1 && break
        n=$((n+1)) 
        sleep 3
    done
fi
chown -R $USER1:$USER_GROUP $USER_HOME

pri "Set password for root"
if [ "$ROOT_PASSWORD" != "" ]; then
    pri "${LBLUE}Automaticly filling password..."
    ( echo $ROOT_PASSWORD; echo $ROOT_PASSWORD; ) | passwd root
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd root && break
        n=$((n+1)) 
        sleep 3
    done
fi

chsh -s /bin/bash root > /dev/null 2>&1

pri "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook


for group in "${PACKAGE_GROUPS[@]}"; do
    CONFIG_FUNC="configure_$group"
    if command -v "$CONFIG_FUNC" &> /dev/null; then
        pri "Configuring $group"
        eval "$CONFIG_FUNC"
    fi
done


mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share

pri "Cleaning up"
rm -f /usr/share/applications/icecat-safe.desktop

pacman --noconfirm -Rs $(pacman -Qqtd)

rm -r /dotfiles 

echo "0" > ~/.cache/update
