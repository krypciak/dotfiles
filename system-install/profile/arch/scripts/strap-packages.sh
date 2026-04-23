#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
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

"$DOTDIR"/system-install/profile/arch/scripts/copy-pacman-config.sh "$INSTALL_DIR"

info_barr "Straping packages"
packages="$(arch_strap_install)"
flag="$([ "$(whoami)" != 'root' ] && echo '-N' || true)"
pacstrap -C "$INSTALL_DIR"/etc/pacman.conf -c -G -M $flag "$INSTALL_DIR" $packages

# restore original config
"$DOTDIR"/system-install/profile/arch/scripts/copy-pacman-config.sh

info "Done"
