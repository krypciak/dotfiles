#!/bin/bash

# _init_browsers() {
#     # Let firefox extensions init
#     doas -u "$USER1" timeout 10s librewolf --headless > /dev/null 2>&1 &
#     doas -u "$USER1" timeout 10s firefox --headless > /dev/null 2>&1 &
# }

arch_browsers_install() {
    echo 'chromium-extension-web-store firefox-pure librewolf-bin ungoogled-chromium-bin'
}
