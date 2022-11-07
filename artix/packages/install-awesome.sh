#!/bin/bash
function install_awesome() {
    wget --quiet https://tools.suckless.org/dmenu/scripts/dmenu_run_with_command_history/dmenu_run_history -O /bin/dmenu_run_history
    chmod +x /bin/dmenu_run_history
    echo 'alacritty awesome breeze breeze-gtk breeze-icons dmenu feh lxappearance qt5-base qt6-base unclutter-xfixes-git xbindkeys xdg-desktop-portal xdotool xkeyboard-config xorg-server xorg-xinit xorg-xprop xorg-xrandr zenity copyq xorg-xmodmap redshift scrot topgrade xdg-utils gtk2 gtk3 qt5ct kolourpaint mpv tutanota-desktop-bin world/gnome-keyring aerc pandoc-bin'
    if [ $INSTALL_CRON -eq 1 ]; then
        echo ' cronie-openrc'
    fi
}

function configure_awesome() {
    if [ $INSTALL_CRON -eq 1 ]; then
        cp $CONFIGD_DIR/cron /var/spool/cron/$USER1
        chown $USER1:$USER1 /var/spool/cron/$USER1
        rc-update add cronie default
    fi
}
