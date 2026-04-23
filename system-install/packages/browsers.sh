#!/bin/bash

_init_browsers() {
    # let librewolf warm up
    doas -u "$USER1" timeout 10s librewolf --headless >/dev/null 2>&1 &
}

arch_browsers_install() {
    echo 'librewolf-bin'
    echo 'ungoogled-chromium-bin chromium-extension-web-store'

    if [ "$TYPE" != 'iso' ]; then
        echo 'firefox'
    fi
}
