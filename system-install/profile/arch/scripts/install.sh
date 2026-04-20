#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

INSTALL_DIR="/mnt/arch"
. "$DIR"/strap-packages.sh
. "$DIR"/chroot-into.sh --cmd /home/"$USER1"/.config/dotfiles/system-install/profile/arch/scripts/after-chroot.sh
