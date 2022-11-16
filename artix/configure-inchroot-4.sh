#!/bin/bash

if [ "$AWESOME_START_TUTANOTA" -eq 0 ]; then
    ESCAPED_T1=$(printf '%s\n' "run_if_not_running_pgrep({ \"tutanota\" }" | sed -e 's/[\/&]/\\&/g')
    sed -i "s/$ESCAPED_T1/--$ESCAPED_T1/g" $USER_HOME/.config/awesome/after_5sec.lua
fi


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


pri "Configuring greetd"
echo "user1: $USER1"
echo "user_home: $USER_HOME, $ESCAPED_USER_HOME"
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/greetd/config.toml
sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
cat /etc/greetd/config.toml
chown greeter:greeter /etc/greetd/config.toml
rc-update add greetd default
rc-update del agetty.tty1 default


mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share

pri "Cleaning up"
rm -f /usr/share/applications/icecat-safe.desktop

pacman --noconfirm -Rs $(pacman -Qqtd)

rm -r /dotfiles 
