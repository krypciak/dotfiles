#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

if [ "$VARIANT" != 'arch' ]; then
    err "Installing to dir is only possible on arch."
    exit 1
fi

_help() {
    printf "Usage:\n"
    printf "    -h --help       Displays this message\n"
    printf "    -y --noconfim   Skips confirmations\n"
    printf "       --dir        Directory to install to\n"
    exit 0
}
handle_args "\
-y|--noconfirm=export YOLO=1,\
--dir:=export INSTALL_DIR=\"\$2\"; export TYPE='dir',\
" "$@"

if [[ ! -v INSTALL_DIR ]]; then
    err "Missing argument: --dir"
    _help
fi

mkdir -p "$INSTALL_DIR"

. "$DOTDIR"/system-install/profile/arch/scripts/strap-packages.sh
. "$DOTDIR"/system-install/profile/arch/scripts/chroot-into.sh --cmd /home/"$USER1"/.config/dotfiles/system-install/profile/arch/scripts/after-chroot.sh

info "Chroot done"
