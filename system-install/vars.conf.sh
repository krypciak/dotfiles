#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1
set -a

PORTABLE=0
KERNEL='linux'
# CACHY_REPOS=1

# User configuration
USER1='krypek'
USER_HOME="/home/$USER1"

USER_PASSWORD='123'
ROOT_PASSWORD='123'

INSTALL_DOTFILES=1
# INSTALL_PRIVATE_DOTFILES=0
# PRIVATE_DOTFILES_PASSWORD=''

REGION='Europe'
CITY='Warsaw'
HOSTNAME1="${USER1}Arch-test"
LANG1='en_US.UTF-8'

# Packages
LIB32=1
PACMAN_ARGUMENTS='--color=always --noconfirm --needed'
PARU_ARGUMENTS='--noremovemake --skipreview --noupgrademenu'

# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=1
if [ "$ALL_DRIVERS" = "0" ]; then
    # NOTE: the only one tested is the amd one

    # Options: amd ati intel nvidia
    # The nvidia driver is the open source one
    GPU='amd'
    # Options: amd intel
    CPU='amd'
fi

PACKAGE_INSTALL_ATTEMPTS=1

PACKAGE_GROUPS=""
PACKAGE_GROUPS="$PACKAGE_GROUPS strap"      # packages installing pre-chroot
PACKAGE_GROUPS="$PACKAGE_GROUPS system"     # bare minimum to get into bash shell
# PACKAGE_GROUPS="$PACKAGE_GROUPS drivers"   # cpu ucode and gpu drivers
PACKAGE_GROUPS="$PACKAGE_GROUPS basic"      # make the shell usable and preety
PACKAGE_GROUPS="$PACKAGE_GROUPS gui"       # platform independent gui apps
PACKAGE_GROUPS="$PACKAGE_GROUPS audio"     # required for audio to work
# PACKAGE_GROUPS="$PACKAGE_GROUPS media"     # ffmpeg, vlc, yt-dlp
# PACKAGE_GROUPS="$PACKAGE_GROUPS browsers"  # dialect, firefox, librewolf, ungoogled-chromium
# PACKAGE_GROUPS="$PACKAGE_GROUPS office"    # libreoffice-fresh
# PACKAGE_GROUPS="$PACKAGE_GROUPS X11"       # X11 server and utilities like screen locker
# PACKAGE_GROUPS="$PACKAGE_GROUPS awesome"   # awesomewm
PACKAGE_GROUPS="$PACKAGE_GROUPS wayland"   # wayland base and utilities like screen locker
PACKAGE_GROUPS="$PACKAGE_GROUPS hyprland"  # hyprland
# PACKAGE_GROUPS="$PACKAGE_GROUPS coding"    # rust, git-filter-repo
# PACKAGE_GROUPS="$PACKAGE_GROUPS java"      # open-jdk stuff
# PACKAGE_GROUPS="$PACKAGE_GROUPS fstools"   # Filesystems, ventoy, testdisk
# PACKAGE_GROUPS="$PACKAGE_GROUPS gaming"    # steam. lib32 libraries, lutris, wine, some drivers, java
# PACKAGE_GROUPS="$PACKAGE_GROUPS security"  # cpu-x, keepassxc, libfido2, libu2f-server, nmap, openbsd-netcat, yubikey-manager-qt
# PACKAGE_GROUPS="$PACKAGE_GROUPS social"    # emojis, webcord
# PACKAGE_GROUPS="$PACKAGE_GROUPS cups"      # printing
# PACKAGE_GROUPS="$PACKAGE_GROUPS bluetooth" # blueman, bluez, bluetooth support at initcpio
# PACKAGE_GROUPS="$PACKAGE_GROUPS virt"      # QEMU
# PACKAGE_GROUPS="$PACKAGE_GROUPS android"   # adb

# Bootloader
VARIANT_NAME="Arch"
BOOTLOADER_ID="$VARIANT_NAME"
if [ -v DISK ]; then
    BOOT_PART="${DISK}1"
    BOOT_SIZE='500M'

    # Encryption
    # 0 -> disable  1 -> enable
    ENCRYPT=1
    if [ "$ENCRYPT" = '1' ]; then
        CRYPT_PART="${DISK}2"
        # None means all remaining space
        CRYPT_SIZE=''
        LUKS_PASSWORD=123

        CRYPT_NAME="$VARIANT"
        CRYPT_FILE="/dev/mapper/$CRYPT_NAME"
        KEY_SIZE=256
        ITER_TIME=3000
        HASH='sha256'
        LUKSFORMAT_ARUGMNETS="--key-size $KEY_SIZE --hash $HASH --iter-time $ITER_TIME"
    else
        LVM_PART="${DISK}2"
        # None means all remaining space
        LVM_SIZE=''
    fi

    # LVM
    ENABLE_SWAP=1
    SWAP_SIZE='16G'
    ROOT_SIZE='50G'
    # user home takes the rest
    LVM_NAME="${VARIANT}_lvm"
    LVM_GROUP_NAME="$VARIANT"
    LVM_DIR="/dev/$LVM_GROUP_NAME"

    # File systems
    BOOT_DIR_ALONE='/boot'

    BOOT_FORMAT_COMMAND="mkfs.fat -n Boot $BOOT_PART"
    BOOT_FSTAB_ARGS="$BOOT_DIR_ALONE    vfat       rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2"

    ROOT_FORMAT_COMMAND="mkfs.btrfs -f -L root $LVM_DIR/root"
    ROOT_FSTAB_ARGS="/  btrfs     	rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/	0 0"

    HOME_FORMAT_COMMAND="mkfs.btrfs -f -L home $LVM_DIR/home"
    HOME_FSTAB_ARGS="$USER_HOME     btrfs      rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/"
fi

# Installer
# Don't ask for confirmation
YOLO=1
AUTO_REBOOT=0
PAUSE_AFTER_DONE=1

set +a
