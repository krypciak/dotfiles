#!/bin/sh
set -a
set -e

[ "$REPOHUB" = '' ] && REPOHUB="$(printf "$(dirname $0)/../../" | xargs realpath)"; . "$REPOHUB"/util.sh
DB="$(printf "$REPOHUB/distrobridge" | xargs realpath)"

if [ -z "$PACKAGE_GROUPS" ]; then
    PACKAGE_GROUPS=""
    PACKAGE_GROUPS="$PACKAGE_GROUPS base"      # packages installing pre-chroot
    PACKAGE_GROUPS="$PACKAGE_GROUPS bare"      # bare minimum to get into bash shell
    PACKAGE_GROUPS="$PACKAGE_GROUPS drivers"   # cpu ucode and gpu drivers
    PACKAGE_GROUPS="$PACKAGE_GROUPS basic"     # make the shell usable and preety
    PACKAGE_GROUPS="$PACKAGE_GROUPS gui"       # platform independent gui apps
    PACKAGE_GROUPS="$PACKAGE_GROUPS audio"     # required for audio to work
    PACKAGE_GROUPS="$PACKAGE_GROUPS media"     # ffmpeg, vlc, youtube-dl, yt-dlp
    PACKAGE_GROUPS="$PACKAGE_GROUPS browsers"  # dialect, firefox, librewolf, ungoogled-chromium
    PACKAGE_GROUPS="$PACKAGE_GROUPS office"    # libreoffice-fresh
    PACKAGE_GROUPS="$PACKAGE_GROUPS X11"       # X11 server and utilities like screen locker
    PACKAGE_GROUPS="$PACKAGE_GROUPS awesome"   # awesomewm
    PACKAGE_GROUPS="$PACKAGE_GROUPS wayland"   # wayland base and utilities like screen locker
    PACKAGE_GROUPS="$PACKAGE_GROUPS dwl"       # dwl (wayland wm)
    PACKAGE_GROUPS="$PACKAGE_GROUPS coding"    # java, rust, eclipse-java (IDE), git-filter-repo
    PACKAGE_GROUPS="$PACKAGE_GROUPS fstools"   # Filesystems, ventoy, testdisk
    PACKAGE_GROUPS="$PACKAGE_GROUPS gaming"    # steam. lib32 libraries, lutris, wine, some drivers, java
    PACKAGE_GROUPS="$PACKAGE_GROUPS security"  # cpu-x, keepassxc, libfido2, libu2f-server, nmap, openbsd-netcat, yubikey-manager-qt
    PACKAGE_GROUPS="$PACKAGE_GROUPS social"    # emojis, discord
    PACKAGE_GROUPS="$PACKAGE_GROUPS misc"      # printing (cups)
    PACKAGE_GROUPS="$PACKAGE_GROUPS bluetooth" # blueman, bluez, bluetooth support at initcpio
    PACKAGE_GROUPS="$PACKAGE_GROUPS virt"      # QEMU
    PACKAGE_GROUPS="$PACKAGE_GROUPS android"   # adb
    PACKAGE_GROUPS="$PACKAGE_GROUPS baltie"    # https://sgpsys.com/en/whatisbaltie.asp
fi

if [ -z "$VARIANT" ];     then VARIANT='artix';     fi
if [ -z "$ALL_DRIVERS" ]; then ALL_DRIVERS='1';     fi
if [ -z "$LIB32" ];       then LIB32='1';           fi
if [ -z "$KERNEL" ];      then KERNEL='linux-zen';  fi

PACKAGE_LIST=''
GROUP_LIST=''
for group in $PACKAGE_GROUPS; do
    . "$DB"/packages/"$group".sh
    INSTALL_FUNC="${VARIANT}_${group}_install"
    if command -v "$INSTALL_FUNC" > /dev/null 2>&1; then
        GROUP_LIST="$GROUP_LIST $group"
        PACKAGE_LIST="$PACKAGE_LIST $($INSTALL_FUNC) "
    fi
done


echo $PACKAGE_LIST | tr ' ' '\n' | sort --unique | xargs
