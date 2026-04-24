#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
export TYPE='disk'
if [[ ! -v DISK ]]; then
    err "\$DISK variable is unset."
    exit 1
fi
source_vars "$DOTDIR"

if [[ ! -v INSTALL_DIR ]]; then
    export INSTALL_DIR=/mnt/arch
fi

if [ ! -e "$CRYPT_FILE" ]; then
    cryptsetup open "$CRYPT_PART" "$CRYPT_NAME"
fi
if [ ! -e "$LVM_DIR"/root ]; then
    vgscan
    vgchange -a y "$LVM_GROUP_NAME"
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
