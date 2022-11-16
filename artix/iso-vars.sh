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
INSTALL_PRIVATE_DOTFILES=0

BOOT_DIR_ALONE='/boot'

# Packages
LIB32=1
PACMAN_ARGUMENTS='--noconfirm --needed'
PARU_ARGUMENTS='--noremovemake --skipreview --noupgrademenu'

PACKAGE_GROUPS=(
    'basic'
    'drivers'
    'gui'
    'audio'
    'media'
    'browsers'
    'X11'
    'awesome'
    'wayland'
    'dwl'
    'coding'
    'fstools'
    'gaming'
    'security'
    'social'
    'misc'
    'bluetooth'
    'virt'
    'android'
)

INSTALL_CRON=0

AWESOME_START_TUTANOTA=0


# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=1
# Options: [ 'amd', 'ati', 'intel', 'nvidia' ]
# The nvidia driver is the open source one
#GPU='amd'
GPU=''
# Options: [ 'amd', 'intel' ]
#CPU='amd'
CPU=''

# Installer
YOLO=1
PAUSE_AFTER_DONE=0


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

