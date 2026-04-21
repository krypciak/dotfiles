#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

# iso ucode reinstall?

cp "$DOTDIR"/system-install/profile/iso/root/etc/doas.conf /etc/doas.conf

printf "#000000" >"$DOTDIR"/user/.config/wallpapers/selected

echo 'export WINIT_X11_SCALE_FACTOR=1.2' >>"$USER_HOME"/.config/at-login.sh

. "$DIR"/run-mkinitcpio.sh
