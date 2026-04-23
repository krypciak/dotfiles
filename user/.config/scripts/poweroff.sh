#!/bin/sh
if command -v systemctl; then
    if [ -f /etc/iso ]; then
        doas systemctl poweroff -ff
    else
        systemctl poweroff
    fi
elif command -v loginctl; then
    loginctl poweroff
fi
