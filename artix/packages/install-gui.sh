#!/bin/bash
function install_gui() {
    echo 'alacritty breeze breeze-gtk breeze-icons feh lxappearance qt5-base qt6-base xdg-desktop-portal zenity topgrade xdg-utils gtk2 gtk3 qt5ct kolourpaint mpv tutanota-desktop-bin world/gnome-keyring aerc pandoc-bin'
    if [ $INSTALL_CRON -eq 1 ]; then
        echo ' cronie-openrc'
    fi
}

function configure_gui() {
    if [ $INSTALL_CRON -eq 1 ]; then
        cp $CONFIGD_DIR/cron_user /var/spool/cron/$USER1
        chown $USER1:$USER1 /var/spool/cron/$USER1

        cp $CONFIGD_DIR/cron_root /var/spool/cron/root
        sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /var/spool/cron/root
        chown root:root /var/spool/cron/root

        rc-update add cronie default
    fi
}
