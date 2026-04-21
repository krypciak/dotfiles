#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

set +e
mkinitcpio -P -R

info "Generating initramfs"
# shellcheck disable=SC2010
KERNEL_VERSION="$(ls /lib/modules/ | grep "$(pacman -Q "$KERNEL" 2>/dev/null | awk '{print $2}')")"
mkinitcpio -g /boot/initramfs-x86_64.img --kernel "$KERNEL_VERSION"
if [ -f /boot/vmlinuz-"$KERNEL" ]; then
    mv /boot/vmlinuz-"$KERNEL" /boot/vmlinuz-x86_64
fi

set -e
