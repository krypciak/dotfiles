#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/..
. "$DOTDIR/util.sh"

check_is_root

_help() {
    printf "Usage:\n"
    printf "    -h --help       Displays this message\n"
    printf "    -y --noconfim   Skips confirmations\n"
    printf "       --disk       Device to install to\n"
    exit 0
}
handle_args "\
-y|--noconfirm=export YOLO=1,\
--disk:=export DISK=\"\$2\",\
" "$@"

if [[ ! -v DISK ]]; then
    err "Missing argument: --disk"
    _help
fi

if [[ ! -v INSTALL_DIR ]]; then
    export INSTALL_DIR=/mnt/arch
fi

export TYPE='disk'
source_vars "$DOTDIR"

if [ "$VARIANT" != 'arch' ]; then
    err "Installing to disk is only possible on arch."
    exit 1
fi

unmount() {
    set +e
    sync
    umount -q "$BOOT_PART" >/dev/null 2>&1
    umount -Rq "$INSTALL_DIR" >/dev/null 2>&1
    swapoff "$LVM_DIR/swap" >/dev/null 2>&1
    lvchange -an "$LVM_GROUP_NAME" >/dev/null 2>&1
    cryptsetup close "$CRYPT_FILE" >/dev/null 2>&1
    umount -q "$CRYPT_FILE" >/dev/null 2>&1
    sync
    set -e
}

fdisk -l "$DISK"
info_garr "Partitioning the disk..."
confirm 'N barr' "Start partitioning <path>$DISK</path>? $RED(DATA WARNING)" '' 'err "Said no to continuation prompt"; exit 1'

info_barr "Unmouting"
unmount
set +e
vgremove -f "$LVM_GROUP_NAME" >/dev/null 2>&1
set -e
unmount

(
    echo g # set partitioning scheme to GPT
    echo n # Create BOOT partition
    echo 1 # partition number 1
    echo   # default - start at beginning of disk
    echo +$BOOT_SIZE
    echo t   # set partition type
    echo 1   # to EFI partition
    echo n   # Create LVM partition
    echo 2   # partion number 2
    echo " " # default, start immediately after preceding partition
    if [ "$ENCRYPT" = '1' ]; then
        if [ "$CRYPT_SIZE" = '' ]; then
            echo
        else
            echo +$CRYPT_SIZE
        fi
    else
        if [ "$LVM_SIZE" = '' ]; then
            echo
        else
            echo +$LVM_SIZE
        fi
    fi
    echo t # set partition type
    echo 2
    echo 44 # to LV
    echo p  # print the in-memory partition table
    echo w  # write changes
    echo q  # quit
) | fdisk $DISK

info "Partitioning finished."

if [ "$ENCRYPT" = '1' ]; then
    info_garr "Setting up encryption on <path>$CRYPT_PART</path>"
    confirm 'N barr' "Setup luks on <path>$CRYPT_PART</path>? $RED(DATA WARNING)" '' 'err "Said no to continuation prompt"; exit 1'
    if [ "$LUKS_PASSWORD" != '' ]; then
        info_barr "Automaticly filling password..."

        if ! echo "$LUKS_PASSWORD" | cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS "$CRYPT_PART"; then
            err "LUKS error"
            exit 1
        fi

        info_barr "Opening <path>$CRYPT_PART</path> as <path>$CRYPT_NAME</path"
        info_barr "Automaticly filling password..."
        if ! echo "$LUKS_PASSWORD" | cryptsetup open "$CRYPT_PART" "$CRYPT_NAME"; then
            err "LUKS error"
            exit 1
        fi
    else
        while true; do

            if cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS "$CRYPT_PART"; then
                break
            fi
            confirm 'Y barr ignore' 'Do you wanna retry?' '' ''
        done

        while true; do
            info_barr "Opening <path>$CRYPT_PART</path> as <path>$CRYPT_NAME</path"
            if cryptsetup open "$CRYPT_PART" "$CRYPT_NAME"; then
                break
            fi
            confirm 'Y barr ignore' 'Do you wanna retry?' '' ''
        done
    fi
    LVM_TARGET_FILE="$CRYPT_FILE"
else
    LVM_TARGET_FILE="$LVM_PART"
fi

info "Setting up LVM on <path>$LVM_TARGET_FILE</path>"

info "Creating LVM group <path>$LVM_GROUP_NAME</path>"
pvcreate --force $LVM_TARGET_FILE || err "LVM error" && exit
vgcreate $LVM_GROUP_NAME $LVM_TARGET_FILE || err "LVM error" && exit

info_garr "Creating volumes"
if [ "$ENABLE_SWAP" = '1' ]; then
    info_barr "Creating SWAP"
    lvcreate -C y -L $SWAP_SIZE $LVM_GROUP_NAME -n swap || err "LVM error" && exit
fi
info_barr "Creating ROOT of size $ROOT_SIZE"
lvcreate -C y -L $ROOT_SIZE $LVM_GROUP_NAME -n root || err "LVM error" && exit

info_barr "Creating HOME of size 100%FREE"
lvcreate -C y -l 100%FREE $LVM_GROUP_NAME -n home || err "LVM error" && exit

info_garr "Formatting volumes"
if [ "$ENABLE_SWAP" = '1' ]; then
    info_barr "SWAP"
    mkswap -L swap $LVM_DIR/swap || err "LVM error" && exit
fi

info_barr "ROOT"
$ROOT_FORMAT_COMMAND || err "LVM error" && exit

info_barr "HOME"
$HOME_FORMAT_COMMAND || err "LVM error" && exit

info_barr "BOOT"
$BOOT_FORMAT_COMMAND || err "LVM error" && exit

info_garr "Mounting volumes"
info_barr "<path>$LVM_DIR/root</path> to <path>$INSTALL_DIR</path>"
mount "$LVM_DIR/root" "$INSTALL_DIR" || err "LVM error" && exit

info "<path>$LVM_DIR/home</path> to <path>$INSTALL_DIR/home/$USER1</path>"
mkdir -p "$INSTALL_DIR/home/$USER1"
mount "$LVM_DIR/home" "$INSTALL_DIR/home/$USER1" || err "LVM error" && exit

info "<path>$BOOT_PART</path> to <path>$BOOT_DIR</path>"
mkdir -p "$BOOT_DIR"
mount "$BOOT_PART" "$BOOT_DIR" || err "LVM error" && exit

if [ "$ENABLE_SWAP" = '1' ]; then
    info "Turning swap on"
    swapon "$LVM_DIR/swap" || err "LVM error" && exit
fi

bash "$DOTDIR"/system-install/install-dir.sh

unmount
