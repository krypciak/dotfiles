#!/bin/sh

# User configuration
USER1="krypek"
USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

USER_PASSWORD=123
ROOT_PASSWORD=123

REGION="Europe"
CITY="Warsaw"
HOSTNAME="krypekartix"
LANG="en_US.UTF-8"


INSTALL_DOTFILES=1
INSTALL_PRIVATE_DOTFILES=1
PRIVATE_DOTFILES_PASSWORD='123'

BOOTLOADER_ID='Artix'
INSTALL_DIR="/mnt"
# Disk managment
DISK="/dev/vda"
BOOT_PART="${DISK}1"
BOOT_SIZE='400M'
CRYPT_PART="${DISK}2"
# None means all remaining space
CRYPT_SIZE=''

BOOT_DIR_ALONE='/boot'
BOOT_DIR=${INSTALL_DIR}${BOOT_DIR_ALONE}

# LUKS
CRYPT_NAME='lvmcrypt'
CRYPT_DIR="/dev/mapper/$CRYPT_NAME"
KEY_SIZE=512
ITER_TIME=5000
HASH='sha512'
LUKSFORMAT_ARUGMNETS="--key-size $KEY_SIZE --hash $HASH --iter-time $ITER_TIME"

# LVM
LVM_PASSWORD=123
SWAP_SIZE='16G'
ROOT_SIZE='50G'
LVM_NAME='artixlvm'
LVM_GROUP_NAME='Artix'

LVM_DIR="/dev/$LVM_GROUP_NAME"

# File systems
BOOT_FORMAT_COMMAND="mkfs.fat -n boot $BOOT_PART"
BOOT_FSTAB_ARGS="$BOOT_DIR_ALONE    vfat       rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2"
ROOT_FORMAT_COMMAND="mkfs.btrfs -f -L root $LVM_DIR/root"
ROOT_FSTAB_ARGS="/  btrfs     	rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/	0 0"
HOME_FORMAT_COMMAND="mkfs.btrfs -f -L home $LVM_DIR/home"
HOME_FSTAB_ARGS="$USER_HOME     btrfs      rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/"

# Packages
LIB32=1
PACMAN_ARGUMENTS='--noconfirm --needed'
PARU_ARGUMENTS='--noremovemake --skipreview --noupgrademenu'

KERNEL='linux-zen'
PACKAGE_GROUPS=(
    'drivers'
    'basic'
    'audio'
    #'media'
    'browsers'
    #'coding'
    #'fstools'
    #'gaming'
    #'security'
    #'social'
    #'misc'
    #'bluetooth'
    #'virt'
    'awesome'
)

INSTALL_CRON=1

# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=1
# Options: [ 'amd', 'ati', 'intel', 'nvidia' ]
# The nvidia driver is the open source one
#GPU='amd'
GPU=''
# Options: [ 'amd', 'intel' ]
#CPU='amd'
CPU=''

AWESOME_START_TUTANOTA=1
AWESOME_START_CMUS=1

# Installer
YOLO=1
AUTO_REBOOT=0
PAUSE_AFTER_DONE=1


LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

function pri() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}


function confirm() {
    echo -en "$LBLUE |||$LGREEN $1 $LBLUE(Y/n/shell)? >> $NC"
    if [ $YOLO -eq 1 ] && [ "$2" != "ignore" ]; then echo "y"; return 0; fi 
    read choice
    case "$choice" in 
    y|Y|"" ) return 0;;
    n|N ) echo -e "$RED Exiting..."; exit;;
    shell ) pri "Entering shell..."; bash; pri "Exiting shell..."; confirm "$1" "ignore"; return 0;;
    * ) confirm "$1" "ignore"; return 0;;
    esac
}

