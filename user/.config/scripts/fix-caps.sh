#!/bin/sh
if [ "$(whoami)" != 'root' ]; then
    echo "run as root"
    exit 1
fi
cp /home/krypek/.config/repohub/distrobridge/profile/common/root/usr/share/X11/xkb/symbols/capslock /usr/share/X11/xkb/symbols/capslock
cp /home/krypek/.config/repohub/distrobridge/profile/common/root/usr/share/kbd/keymaps/us-nocaps.map /usr/share/kbd/keymaps/us-nocaps.map
