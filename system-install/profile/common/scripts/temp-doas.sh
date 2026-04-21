#!/bin/bash
set -e
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1

check_is_root


info "Creating temporary doas config"

echo "permit nopass setenv { YOLO USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS PACKAGE_LIST } root" >/etc/doas.conf
echo "permit nopass setenv { YOLO USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS PACKAGE_LIST } $USER1" >>/etc/doas.conf
chown root:root /etc/doas.conf
chmod 0040 /etc/doas.conf
