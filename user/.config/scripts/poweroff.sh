#!/bin/sh
if command -v systemctl >/dev/null; then
    if [ -f /etc/iso ]; then
        doas systemctl poweroff -ff
    else
        systemctl poweroff
    fi
elif command -v loginctl >/dev/null; then
    loginctl poweroff
fi
