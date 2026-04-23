#!/bin/sh
if command -v systemctl; then
    if [ -f /etc/iso ]; then
        doas systemctl reboot -ff
    else
        systemctl reboot
    fi
elif command -v loginctl; then
    loginctl reboot
fi
