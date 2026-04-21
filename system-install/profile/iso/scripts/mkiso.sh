#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1
set -e

info "Building the ISO"
DATE=$(date -u +%Y-%m-%d-%H-%M-%S-00 | sed -e s/-//g)

xorriso -as mkisofs \
    --modification-date="$DATE" \
    --protective-msdos-label \
    -volid "$VARIANT-iso" \
    -appid "$VARIANT_NAME" \
    -preparer "Prepared by krypciak/dotfiles install script" \
    -r -graft-points -no-pad \
    --sort-weight 0 / \
    --sort-weight 1 /boot \
    --grub2-mbr "$ISO_ROOT"/boot/grub/i386-pc/boot_hybrid.img \
    -partition_offset 16 \
    -b boot/grub/i386-pc/eltorito.img \
    -c boot.catalog \
    -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
    -eltorito-alt-boot \
    -append_partition 2 0xef "$ISO_ROOT"/boot/efi.img \
    -e --interval:appended_partition_2:all:: -iso_mbr_part_type 0x00 \
    -no-emul-boot \
    -iso-level 3 \
    -o "$ISO_OUT_FILE" \
    "$ISO_ROOT"/
