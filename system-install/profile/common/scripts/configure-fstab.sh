#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Configuring fstab"
sed -i "s|ROOT_UUID|$(blkid "$LVM_DIR"/root -s UUID -o value)|g" /etc/fstab
[ "$ENABLE_SWAP" = '1' ] && sed -i "s|SWAP_UUID|$(blkid "$LVM_DIR"/swap -s UUID -o value)|g" /etc/fstab
sed -i "s|HOME_UUID|$(blkid "$LVM_DIR"/home -s UUID -o value)|g" /etc/fstab
sed -i "s|BOOT_UUID|$(blkid "$BOOT_PART" -s UUID -o value)|g" /etc/fstab
sed -i "s|BOOT_PART|$BOOT_PART|g" /etc/fstab
sed -i "s|LVM_GROUP_NAME|$LVM_GROUP_NAME|g" /etc/fstab
sed -i "s|ROOT_FSTAB_ARGS|$ROOT_FSTAB_ARGS|g" /etc/fstab
sed -i "s|HOME_FSTAB_ARGS|$HOME_FSTAB_ARGS|g" /etc/fstab
sed -i "s|BOOT_FSTAB_ARGS|$BOOT_FSTAB_ARGS|g" /etc/fstab
