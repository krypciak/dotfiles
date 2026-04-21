#!/bin/bash

_configure_awesome() {
    if [ "$PORTABLE" = 1 ]; then
        cd "$USER_HOME"/.config/awesome || exit 1

        sed -i 's/run_if_not_running_pgrep({"redshift/--run_if_not_running_pgrep({"redshift/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("keepassxc/--run_if_not_running_pgrep("keepassxc/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep({"tutanota/--run_if_not_running_pgrep({"tutanota/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("blueman-applet/--run_if_not_running_pgrep("blueman-applet/g' autostart.lua
    fi
}

arch_awesome_install() {
    echo 'awesome'
}

arch_awesome_configure() {
    _configure_awesome
}

