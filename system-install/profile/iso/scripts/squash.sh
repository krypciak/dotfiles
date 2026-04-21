#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1
set -e

#if ${persist};then
#    make_ext_img "${sfs_in}"
#    mksfs_args+=("${work_dir}/embed")
#else

mkdir -p "$ISO_LIVEOS"

info "Generating the SquashFS image"
mksquashfs "$ISO_ROOTFS" "$ISO_LIVEOS"/rootfs.img -comp zstd -Xcompression-level 15 -noappend

cd "$ISO_LIVEOS"
md5sum rootfs.img >rootfs.img.md5
