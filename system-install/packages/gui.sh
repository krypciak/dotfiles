#!/bin/bash

arch_gui_install() {
    echo 'alacritty feh gnome-keyring dolphin'
    echo 'qt5-base qt6-base qt5ct qt6ct breeze breeze5 breeze-gtk breeze-icons gtk2 gtk3 lxappearance'
    echo 'xdg-desktop-portal xdg-utils'

    echo 'fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-breeze fcitx5-mozc'

    if [ "$PORTABLE" = 0 ]; then
        echo 'safeeyes'
    fi
}
