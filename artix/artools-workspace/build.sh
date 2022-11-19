#!/bin/sh
if [ $(whoami) != "root" ]; then
    echo "This script requires root privilages"
    exit 1
fi
paru --noconfirm -Syu

ARTIX_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROFILE='krypek'
CURRENT_USER='krypek'
NEW_USER='krypek'

BUILDISO_DIR="$ARTIX_DIR/buildiso"
ROOTFS="$BUILDISO_DIR/$PROFILE/artix/rootfs"

FINAL_ISO_DIR="/home/$CURRENT_USER/VM/iso/"
BUILDISO_ARGS="-p $PROFILE -r $BUILDISO_DIR -t $FINAL_ISO_DIR"


PACMAN_CACHE='/var/cache/pacman/pkg'
PARU_CACHE='.cache/paru/clone'

CURRENT_PARU_CACHE="/home/$CURRENT_USER/$PARU_CACHE"
NEW_PARU_CACHE="$ROOTFS/home/$NEW_USER/$PARU_CACHE"

CURRENT_CARGO_CACHE="/home/$CURRENT_USER/.cargo"
NEW_CARGO_CACHE="$ROOTFS/home/$NEW_USER/.cargo"

function unmount_cache() {
    umount "$ROOTFS$PACMAN_CACHE" > /dev/null 2>&1
    umount "$NEW_PARU_CACHE" > /dev/null 2>&1
    umount "$NEW_CARGO_CACHE" > /dev/null 2>&1
}

function mount_cache() {
    mount --bind "$PACMAN_CACHE" "$ROOTFS$PACMAN_CACHE" --mkdir
    mount --bind "$CURRENT_PARU_CACHE" "$NEW_PARU_CACHE" --mkdir
    mount --bind "$CURRENT_CARGO_CACHE" "$NEW_CARGO_CACHE" --mkdir
}

function unmount_spdirs() {
    umount -R "$ROOTFS/proc" > /dev/null 2>&1
    umount -R "$ROOTFS/sys" > /dev/null 2>&1
    
    #mount --make-rslave "$ROOTFS/dev"
    umount -lf "$ROOTFS/dev" > /dev/null 2>&1
}

function mount_spdirs() {
    mount -t proc '/proc' "$ROOTFS/proc"
    mount -t sysfs '/sys' "$ROOTFS/sys"
    mount -o bind '/dev' "$ROOTFS/dev"
    #mount -t devpts '/dev/pts' "$ROOTFS/dev/pts"
}



# make sure everything is unmounted
unmount_spdirs
unmount_cache
umount -R "$ROOTFS" > /dev/null 2>&1

rm --one-file-system -rf $BUILDISO_DIR
# install base packages so it's chroot'able
buildiso $BUILDISO_ARGS -x


# mount special dirs
mount_spdirs
cp /etc/resolv.conf $ROOTFS/etc/

# disable pacman checking space
#sed -i 's/CheckSpace/#CheckSpace/g' $ROOTFS/etc/pacman.conf

# mount pacman and paru package cache
mkdir -p $ROOTFS/var/lib/pacman/sync
cp /var/lib/pacman/sync/*.db $ROOTFS/var/lib/pacman/sync/
mount_cache

# chroot
cp after-chroot.sh $ROOTFS/
chroot $ROOTFS/ /after-chroot.sh "yes!"

unmount_spdirs
unmount_cache
chown $CURRENT_USER:$CURRENT_USER -R $CURRENT_PARU_CACHE
chown $CURRENT_USER:$CURRENT_USER -R $CURRENT_CARGO_CACHE

buildiso $BUILDISO_ARGS -sc

buildiso $BUILDISO_ARGS -bc

buildiso $BUILDISO_ARGS -zc

# clean up
rm --one-file-system -rf $BUILDISO_DIR

chown krypek:krypek -R $FINAL_ISO_DIR
