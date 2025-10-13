#!/bin/sh

rm -f /run/greetd.run
if command -v systemctl; then
    echo a
    systemctl soft-reboot
# elif command -v loginctl; then
#     loginctl reboot
fi
