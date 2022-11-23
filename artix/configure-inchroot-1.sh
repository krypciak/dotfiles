#!/bin/bash

export DOTFILES_DIR=$ARTIXD_DIR/..
export CONFIGD_DIR=$DOTFILES_DIR/config-files

export ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')

export PACMAN_ARGUMENTS
export PARU_ARGUMENTS
export YOLO
export USER1
export PRIVATE_DOTFILES_PASSWORD


pri "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

pri "Generating locale"
cp $CONFIGD_DIR/root/etc/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LANG
export LC_COLLATE="C"

pri "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" > /etc/conf.d/hostname

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf


