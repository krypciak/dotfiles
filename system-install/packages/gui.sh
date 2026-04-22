#!/bin/bash

arch_gui_install() {
    echo 'alacritty breeze feh gnome-keyring'
    echo 'qt5-base qt5ct qt6-base breeze-gtk breeze-icons gtk2 gtk3 lxappearance'
    echo 'xdg-desktop-portal xdg-utils'

    echo 'fcitx5 fcitx-configtool fcitx5-gtk fcitx5-qt fcitx5-mozc'

    if [ "$PORTABLE" = 0 ]; then
        echo 'safeeyes'
    fi
}
