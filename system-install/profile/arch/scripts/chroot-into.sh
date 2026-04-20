#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

_help() {
    printf "Usage:\n"
    printf "    -h --help      Displays this message\n"
    printf "       --dir DIR   Install dir\n"
    printf "       --cmd CMD   Command to run\n"
    exit 1
}

handle_args "\
--dir:=export INSTALL_DIR=\"\$2\",\
--cmd:=export CMD_TO_RUN=\"\$2\",\
" "$@"

if [ "$INSTALL_DIR" == "" ]; then
    err "Argument missing: --dir"
    _help
fi

if [ "$CMD_TO_RUN" == "" ]; then
    CMD_TO_RUN=/bin/sh
fi

info_garr "Preparing to chroot into <path>$INSTALL_DIR</path>"

info_barr "Copying dotfiles"
DEST_DOTFILES_DIR="$INSTALL_DIR/home/$USER1/.config/dotfiles"
mkdir -p "$DEST_DOTFILES_DIR"
cp -r "$DOTDIR" "$DEST_DOTFILES_DIR"

info_barr "Chrooting"

# genfstab -U "$INSTALL_DIR" > "$INSTALL_DIR"/etc/fstab
arch-chroot "$INSTALL_DIR" $CMD_TO_RUN
