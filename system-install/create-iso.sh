#!/bin/bash
export TYPE='iso'

DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

_help() {
    printf "Usage:\n"
    printf "    -h --help              Displays this message\n"
    printf "    -y --noconfim          Skips confirmations\n"
    printf "       --iso ISO           Destination directory for .iso image\n"
    printf "       --iso-copy-to DIR   Copy the iso to that dir and delete all previous variant iso's\n"
    printf "       --wait-for-dir DIR  Dont start iso build until that dir is mounted\n"
    exit 1
}

ISO_COPY_TO_DIR=''
ISO_WAIT_FOR_DIR=''
handle_args "\
-y|--noconfirm=export YOLO=1,\
--iso:=export ISO_OUT_DIR=\"\$2\",\
--iso-copy_to:=export ISO_COPY_TO_DIR=\"\$2\",\
--wait-for-dir:=export ISO_WAIT_FOR_DIR=\"\$2\",\
" "$@"

if [ "$ISO_OUT_DIR" = '' ]; then
    err "Missing argument (required for --mode=iso): --iso"
    _help
fi

if [ "$OS_VARIANT" != 'arch' ]; then
    err "Creating iso is only possible on arch."
    exit 1
fi

export VARIANT="arch"

ISO_OUT_FILENAME="$VARIANT-iso-$(date -u +%Y-%m-%d).iso"
ISO_OUT_FILE="$(echo "$ISO_OUT_DIR/$ISO_OUT_FILENAME" | xargs realpath)"

ISO_WORK_DIR="/mnt/$VARIANT-iso"

ISO_ROOT="$ISO_WORK_DIR/iso"
ISO_LIVEOS="$ISO_ROOT/LiveOS"
ISO_ROOTFS="$ISO_WORK_DIR/rootfs"
export INSTALL_DIR="$ISO_ROOTFS"

info "Building iso..."

_wait_dir_mount() {
    set +e
    RETURN="$(umount "$ISO_WAIT_FOR_DIR" 2>/dev/stdout)"
    if [ "$(echo "$RETURN" | grep 'target is busy')" != '' ]; then
        err "<path>$ISO_WAIT_FOR_DIR</path>${RED} is busy."
        exit 1
    fi
    set -e
    if [ "$ISO_WAIT_FOR_DIR" != '' ]; then
        info_barr "Waiting for <path>${ISO_WAIT_FOR_DIR}</path> to be available..."
        mount "$ISO_WAIT_FOR_DIR" >/dev/null 2>&1
        while [ "$(grep "$ISO_WAIT_FOR_DIR" /etc/mtab)" = '' ]; do
            sleep 2
            mount "$ISO_WAIT_FOR_DIR"
        done
        info_barr "Mounted."
    fi
}

_wait_dir_mount

bash "$DOTDIR"/system-install/install-dir.sh

mkdir -p "$ISO_ROOT"/boot
cp "$ISO_ROOTFS"/boot/initramfs-x86_64.img "$ISO_ROOTFS"/boot/*-ucode.img "$ISO_ROOT"/boot/

. "$DOTDIR"/system-install/profile/iso/scripts/grub.sh

. "$DOTDIR"/system-install/profile/iso/scripts/squash.sh

. "$DOTDIR"/system-install/profile/iso/scripts/mkiso.sh

if [ "$DEV" != "1" ]; then
    rm -rf "$ISO_ROOT"
fi

chown_user "$ISO_OUT_FILE"
info "Building ISO done."
echo "$ISO_OUT_FILE"
if command -v dust; then
    dust "$ISO_OUT_FILE"
else
    du -h "$ISO_OUT_FILE"
fi

if [ "$ISO_COPY_TO_DIR" != '' ]; then
    _wait_dir_mount
    info "Copying the iso to <path>${ISO_COPY_TO_DIR}</path> ..."
    rm -f "$ISO_WAIT_FOR_DIR"/$VARIANT-iso*
    if command -v pv >/dev/null 2>&1; then
        pv "$ISO_OUT_FILE" >"$ISO_WAIT_FOR_DIR/$ISO_OUT_FILENAME"
    else
        cp "$ISO_OUT_FILE" "$ISO_WAIT_FOR_DIR"
    fi
    info "Syncing..."
    sync
    info "Unmounting..."
    umount "$ISO_WAIT_FOR_DIR"
    info "Done."
    info "You can unplug your device now"
fi
