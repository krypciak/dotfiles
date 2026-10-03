#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

# housekeeping: rebuild the presets, then drop them again. Not fatal on its own.
set +e
mkinitcpio -P -R
set -e

info "Generating initramfs"
# The package version and the module directory name differ
# ('7.2.8.arch1-2' vs '7.2.8-arch1-2'), so take the directory straight from
# the kernel package's file list instead of pattern matching the version.
KERNEL_VERSION="$(pacman -Ql "$KERNEL" 2>/dev/null | awk -F/ '{for (i = 1; i < NF; i++) if ($i == "modules" && $(i + 1) != "") { print $(i + 1); exit }}')"
if [ -z "$KERNEL_VERSION" ]; then
    err "Could not find the module directory of kernel package '$KERNEL'"
    exit 1
fi
info_barr "Kernel version: $KERNEL_VERSION"
mkinitcpio -g /boot/initramfs-x86_64.img --kernel "$KERNEL_VERSION"
if [ -f /boot/vmlinuz-"$KERNEL" ]; then
    mv /boot/vmlinuz-"$KERNEL" /boot/vmlinuz-x86_64
fi
