#!/bin/bash
function install_awesome() {
    echo 'alacritty awesome breeze breeze-gtk breeze-icons feh lxappearance qt5-base qt6-base unclutter-xfixes-git xbindkeys xdg-desktop-portal xdotool xkeyboard-config xorg-server xorg-xinit xorg-xprop xorg-xrandr zenity xorg-xmodmap redshift scrot topgrade xdg-utils gtk2 gtk3 qt5ct kolourpaint mpv tutanota-desktop-bin world/gnome-keyring aerc pandoc-bin xsel'
    if [ $INSTALL_CRON -eq 1 ]; then
        echo ' cronie-openrc'
    fi
}

function configure_awesome() {
    if [ $INSTALL_CRON -eq 1 ]; then
        cp $CONFIGD_DIR/cron_user /var/spool/cron/$USER1
        chown $USER1:$USER1 /var/spool/cron/$USER1

        cp $CONFIGD_DIR/cron_root /var/spool/cron/root
        chown root:root /var/spool/cron/root

        rc-update add cronie default
    fi
}
