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

set +e
info "Unmounting all (there may be errors)"
sync
set -x
umount -q "$BOOT_PART"
umount -Rq "$INSTALL_DIR"
swapoff "$LVM_DIR/swap"
lvchange -an "$LVM_GROUP_NAME"
cryptsetup close "$CRYPT_FILE"
umount -q "$CRYPT_FILE"
sync
set +x
set -e
