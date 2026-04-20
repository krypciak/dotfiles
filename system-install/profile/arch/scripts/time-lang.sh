#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
echo "$REGION/$CITY" >/etc/timezone

systemctl enable --now systemd-timesyncd
sleep 1
hwclock --systohc

info "Generating locale"
cp "$DOTDIR"/system-install/profile/common/root/etc/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG1\"" >/etc/locale.conf
export LC_COLLATE="C"

info "Setting the hostname"
echo "$HOSTNAME1" >/etc/hostname
mkdir -p /etc/conf.d
echo "hostname='$HOSTNAME1'" >/etc/conf.d/hostname
