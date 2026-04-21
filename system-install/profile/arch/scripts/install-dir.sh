#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

_help() {
    printf "Usage:\n"
    printf "    -h --help       Displays this message\n"
    printf "    -y --noconfim   Skips confirmations\n"
    printf "       --dir        Directory to install to\n"
    exit 0
}
handle_args "\
-y|--noconfirm=export YOLO=1,\
--dir:=export INSTALL_DIR=\"\$2\"; export MODE='dir',\
" "$@"

if [ "$INSTALL_DIR" = '' ]; then
    err "Missing argument: --dir"
    _help
fi

mkdir -p "$INSTALL_DIR"

. "$DIR"/strap-packages.sh
. "$DIR"/chroot-into.sh --cmd /home/"$USER1"/.config/dotfiles/system-install/profile/arch/scripts/after-chroot.sh

info "Chroot done"
