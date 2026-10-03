#!/bin/sh
if command -v systemctl >/dev/null; then
    if [ -f /etc/iso ]; then
        sudo systemctl reboot -ff
    else
        systemctl reboot
    fi
elif command -v loginctl >/dev/null; then
    loginctl reboot
fi
