#!/bin/bash

arch_bluetooth_install() {
    echo 'blueman bluetooth-autoconnect bluez bluez-utils'
}

arch_bluetooth_configure() {
    if [ "$TYPE" != 'iso' ]; then
        systemctl enable bluetooth
        systemctl enable bluetooth-autoconnect
    fi
}
