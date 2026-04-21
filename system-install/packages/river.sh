#!/bin/sh

_make_sandbar() {
    info 'Compiling sandbar'

    cd "$USER_HOME"/.config/river/sandbar/
    doas -u "$USER1" make
}

_configure_river() {
    set +e
    _make_sandbar
    set -e
    chown "$USER1:$USER_GROUP" -R "$USER_HOME"/.config/river
}


artix_river_install() {
    echo 'river-git xdg-desktop-portal-wlr filtile-git'
}

arch_river_install() {
    echo 'river-git xdg-desktop-portal-wlr filtile-git'
}

artix_river_configure() {
    _configure_river
    echo
}

arch_river_configure() {
    _configure_river
    echo
}

