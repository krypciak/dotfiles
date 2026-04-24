#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
export TYPE='disk'
source_vars "$DOTDIR"

if [[ ! -v INSTALL_DIR ]]; then
    export INSTALL_DIR=/mnt/arch
fi

info_garr "Mounting volumes"
info_barr "<path>$LVM_DIR/root</path> to <path>$INSTALL_DIR</path>"
mount "$LVM_DIR/root" "$INSTALL_DIR"

info "<path>$LVM_DIR/home</path> to <path>$INSTALL_DIR/home/$USER1</path>"
mkdir -p "$INSTALL_DIR/home/$USER1"
mount "$LVM_DIR/home" "$INSTALL_DIR/home/$USER1"

BOOT_DIR="$INSTALL_DIR$BOOT_DIR_ALONE"
info "<path>$BOOT_PART</path> to <path>$BOOT_DIR</path>"
mkdir -p "$BOOT_DIR"
mount "$BOOT_PART" "$BOOT_DIR"

if [ "$ENABLE_SWAP" = '1' ]; then
    info "Turning swap on"
    swapon "$LVM_DIR/swap"
fi
