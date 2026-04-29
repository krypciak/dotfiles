#!/bin/sh
if command -v systemctl >/dev/null; then
    if [ -f /etc/iso ]; then
        doas systemctl reboot -ff
    else
        systemctl reboot
    fi
elif command -v loginctl >/dev/null; then
    loginctl reboot
fi
