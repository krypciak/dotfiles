#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info_garr "Configuring grub"

if [ "$TYPE" = 'dir' ]; then
    BOOT_DIR_ALONE='/boot'
elif [ "$TYPE" = 'disk' ]; then
    # GRUB_CMDLINE_LINUX="cryptdevice=UUID=CRYPT_UUID:CRYPT_NAME root=/dev/mapper/LVM_GROUP_NAME-root resume=UUID=SWAP_UUID"

    [ "$ENABLE_SWAP" = '1' ] && sed -i "s|SWAP_UUID|$(blkid "$LVM_DIR"/swap -s UUID -o value)|g" /etc/default/grub
    sed -i "s|LVM_GROUP_NAME|$LVM_GROUP_NAME|g" /etc/default/grub
    if [ "$ENCRYPT" = '1' ]; then
        sed -i "s/CRYPT_UUID/$(blkid "$CRYPT_PART" -s UUID -o value)/g" /etc/default/grub
        sed -i "s|CRYPT_NAME|$CRYPT_NAME|g" /etc/default/grub
    fi
else
    err "configure-fstab: unknown install type: $TYPE"
    exit 1
fi

info_barr "Installing crossgrub theme"
git clone https://github.com/krypciak/crossgrub /tmp/crossgrub
mkdir -p /boot/grub/themes
bash /tmp/crossgrub/install.sh

info_barr "Installing grub to <path>$BOOT_DIR_ALONE</path>"
grub-install --target=x86_64-efi --efi-directory="$BOOT_DIR_ALONE" --bootloader-id="$BOOTLOADER_ID"

info_barr "Generating grub config"
grub-mkconfig -o /boot/grub/grub.cfg

