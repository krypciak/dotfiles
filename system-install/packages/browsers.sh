#!/bin/bash

_init_browsers() {
    # let firefox warm up
    doas -u "$USER1" timeout 10s firefox --headless >/dev/null 2>&1 &
}

arch_browsers_install() {
    echo 'firefox'
    echo 'ungoogled-chromium-bin chromium-extension-web-store'
}
