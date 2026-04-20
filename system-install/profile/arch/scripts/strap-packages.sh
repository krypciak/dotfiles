#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

source_vars "$DOTDIR"

_help() {
    printf "Usage:\n"
    printf "    -h --help      Displays this message\n"
    printf "       --dir DIR   Install dir\n"
    exit 1
}

handle_args "\
--dir:=export INSTALL_DIR=\"\$2\",\
" "$@"

if [ "$INSTALL_DIR" == "" ]; then
    err "Argument missing: --dir"
    _help
fi

info_garr "Preparing to strap packages into <path>$INSTALL_DIR</path>"

. "$DOTDIR"/system-install/packages/strap.sh

mkdir -p "$INSTALL_DIR"/etc
mkdir -p "$INSTALL_DIR"/tmp
mkdir -p "$INSTALL_DIR"/var/lib/pacman
mkdir -p "$INSTALL_DIR"/var/cache/pacman/pkg

cp -r "$DOTDIR"/system-install/profile/arch/root/etc/pacman.conf "$INSTALL_DIR"/etc/
cp -r "$DOTDIR"/system-install/profile/arch/root/etc/pacman.d "$INSTALL_DIR"/etc/

sed -i -e "s|\(\/etc/pacman.d\/mirrorlist\)|$INSTALL_DIR\1|g" "$INSTALL_DIR"/etc/pacman.conf

info_barr "Straping packages"
packages="$(arch_base_install)"
flag="$([ "$(whoami)" != 'root' ] && echo '-N' || true)"
pacstrap -C "$INSTALL_DIR"/etc/pacman.conf -c -K -M $flag "$INSTALL_DIR" $packages

info "Done"
