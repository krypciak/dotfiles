#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Configuring fstab"
if [ "$TYPE" = 'dir' ]; then
    cp /etc/fstab-gen /etc/fstab
elif [ "$TYPE" = 'disk' ]; then
    cp "$DOTDIR/system-install/profile/common/configs/fstab-lvm" /etc/fstab
    sed -i "s|ROOT_UUID|$(blkid "$LVM_DIR"/root -s UUID -o value)|g" /etc/fstab
    [ "$ENABLE_SWAP" = '1' ] && sed -i "s|SWAP_UUID|$(blkid "$LVM_DIR"/swap -s UUID -o value)|g" /etc/fstab
    sed -i "s|HOME_UUID|$(blkid "$LVM_DIR"/home -s UUID -o value)|g" /etc/fstab
    sed -i "s|BOOT_UUID|$(blkid "$BOOT_PART" -s UUID -o value)|g" /etc/fstab
    sed -i "s|BOOT_PART|$BOOT_PART|g" /etc/fstab
    sed -i "s|ROOT_FSTAB_ARGS|$ROOT_FSTAB_ARGS|g" /etc/fstab
    sed -i "s|HOME_FSTAB_ARGS|$HOME_FSTAB_ARGS|g" /etc/fstab
    sed -i "s|BOOT_FSTAB_ARGS|$BOOT_FSTAB_ARGS|g" /etc/fstab
else
    err "configure-fstab: unknown install type: $TYPE"
    exit 1
fi

cat "$DOTDIR/system-install/profile/common/configs/fstab-ending" >>/etc/fstab
