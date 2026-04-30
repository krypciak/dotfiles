#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info_garr "Configuring grub"

flags=""
if [ "$TYPE" = 'dir' ]; then
    BOOT_DIR_ALONE='/boot'
elif [ "$TYPE" = 'disk' ]; then
    flags="$flags root=/dev/mapper/$LVM_GROUP_NAME-root"
    if [ "$ENABLE_SWAP" ]; then
        SWAP_UUID="$(blkid "$LVM_DIR"/swap -s UUID -o value)"
        flags="$flags resume=UUID=$SWAP_UUID"
    fi

    if [ "$ENCRYPT" = '1' ]; then
        CRYPT_UUID="$(blkid "$CRYPT_PART" -s UUID -o value)"
        flags="cryptdevice=UUID=$CRYPT_UUID:$CRYPT_NAME $flags"

        if ! grep -qw "encrypt" /etc/mkinitcio.conf; then
            sed -i 's|block|\0 encrypt|g' /etc/mkinitcpio.conf
        fi
    fi
else
    err "configure-fstab: unknown install type: $TYPE"
    exit 1
fi

sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"|\0 ${flags}|g" /etc/default/grub

if [ "$INSTALL_GRUB_THEME" = '1' ]; then
    info_barr "Installing crossgrub theme"
    git clone https://github.com/krypciak/crossgrub /tmp/crossgrub
    mkdir -p /boot/grub/themes
    bash /tmp/crossgrub/install.sh

    sed -i 's|# GRUB_THEME=""|GRUB_THEME="/boot/grub/themes/crossgrub/theme.txt"|g' /etc/default/grub
fi

info_barr "Installing grub to <path>$BOOT_DIR_ALONE</path>"
grub-install --target=x86_64-efi --efi-directory="$BOOT_DIR_ALONE" --bootloader-id="$BOOTLOADER_ID"

info_barr "Generating grub config"
grub-mkconfig -o /boot/grub/grub.cfg
