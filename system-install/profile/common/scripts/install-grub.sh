#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

[ "$ENABLE_SWAP" = '1' ] && sed -i "s|SWAP_UUID|$(blkid "$LVM_DIR"/swap -s UUID -o value)|g" /etc/default/grub
sed -i "s|LVM_GROUP_NAME|$LVM_GROUP_NAME|g" /etc/default/grub
if [ "$ENCRYPT" = '1' ]; then
    sed -i "s/CRYPT_UUID/$(blkid "$CRYPT_PART" -s UUID -o value)/g" /etc/default/grub
    sed -i "s|CRYPT_NAME|$CRYPT_NAME|g" /etc/default/grub
fi

if [ "$TYPE" != 'dir' ]; then
    info "Installing grub to <path>$BOOT_DIR_ALONE</path>"
    grub-install --target=x86_64-efi --efi-directory="$BOOT_DIR_ALONE" --bootloader-id="$BOOTLOADER_ID"

    info "Generating grub config"
    grub-mkconfig -o /boot/grub/grub.cfg
fi
