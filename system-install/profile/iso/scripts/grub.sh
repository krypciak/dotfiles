#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1

info "Generating grub images"

sed -i -e "s|VARIANT|$VARIANT|g" "$ISO_ROOTFS"/etc/default/grub

ro_opts=""
rw_opts=""
kopts="label=$VARIANT-iso"

sed -e "s|@kopts@|$kopts|" \
    -e "s|@ro_opts@|$ro_opts|" \
    -e "s|@rw_opts@|$rw_opts|" \
    -i "$ISO_ROOTFS"/usr/share/grub/cfg/kernels.cfg

sed -i -e "s|VARIANT_NAME|$VARIANT_NAME|g" "$ISO_ROOTFS"/usr/share/grub/cfg/kernels.cfg
sed -i -e "s|VARIANT|$VARIANT|g" "$ISO_ROOTFS"/usr/share/grub/cfg/kernels.cfg

mkdir -p "$ISO_ROOT"/boot/grub/i386-pc

mkdir -p "$ISO_ROOT"/efi/boot
mkdir -p "$ISO_ROOT"/boot/grub/x86_64-efi

cp "$DOTDIR"/system-install/profile/iso/configs/${VARIANT}-logo.png "$ISO_ROOTFS"/usr/share/grub/themes/iso/logo.png

cp -r "$ISO_ROOTFS"/usr/share/grub/* "$ISO_ROOT"/boot/grub/
rm -r "$ISO_ROOT"/boot/grub/cfg
cp "$ISO_ROOTFS"/usr/share/grub/cfg/*.cfg "$ISO_ROOT"/boot/grub/

cp "$ISO_ROOTFS"/usr/lib/grub/i386-pc/* "$ISO_ROOT"/boot/grub/i386-pc
cp "$ISO_ROOTFS"/usr/lib/grub/x86_64-efi/* "$ISO_ROOT"/boot/grub/x86_64-efi

cp -r "$ISO_ROOTFS"/boot/vmlinuz-x86_64 "$ISO_ROOT"/boot/

cp "$ISO_ROOTFS"/boot/memtest86+/memtest.bin "$ISO_ROOT"/boot/memtest

grub-mkimage -d "$ISO_ROOT"/boot/grub/i386-pc -o "$ISO_ROOT"/boot/grub/i386-pc/core.img -O i386-pc -p /boot/grub biosdisk iso9660

cat "$ISO_ROOT"/boot/grub/i386-pc/cdboot.img "$ISO_ROOT"/boot/grub/i386-pc/core.img >"$ISO_ROOT"/boot/grub/i386-pc/eltorito.img

grub-mkimage -d "$ISO_ROOT"/boot/grub/x86_64-efi -o "$ISO_ROOT"/efi/boot/bootx64.efi -O x86_64-efi -p /boot/grub iso9660

truncate -s '4M' "$ISO_ROOT"/boot/efi.img
mkfs.fat -n "$(echo $VARIANT | tr '[:lower:]' '[:upper:]')_EFI" "$ISO_ROOT"/boot/efi.img

mkdir -p "$ISO_ROOTFS"/tmp/efiboot
mount "$ISO_ROOT"/boot/efi.img "$ISO_ROOTFS"/tmp/efiboot
mkdir -p "$ISO_ROOTFS"/tmp/efiboot/efi/boot

grub-mkimage -d "$ISO_ROOT"/boot/grub/x86_64-efi -o "$ISO_ROOTFS"/tmp/efiboot/efi/boot/bootx64.efi -O x86_64-efi -p /boot/grub iso9660
umount "$ISO_ROOTFS"/tmp/efiboot
