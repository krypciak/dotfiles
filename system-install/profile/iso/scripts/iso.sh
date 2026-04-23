#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

touch /etc/iso

pacman $PACMAN_ARGUMENTS -S intel-ucode amd-ucode

cp "$DOTDIR"/system-install/profile/iso/root/etc/doas.conf /etc/doas.conf

printf "#000000" >"$DOTDIR"/user/.config/wallpapers/selected

. "$DIR"/run-mkinitcpio.sh
