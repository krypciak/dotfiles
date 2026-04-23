#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Initializng pacman"

pacman-key --init
pacman-key --populate

"$DIR"/copy-pacman-config.sh

sed -i 's|#PACMAN_AUTH=()|PACMAN_AUTH=(doas)|' /etc/makepkg.conf
sed -i 's|#MAKEFLAGS="-j2"|MAKEFLAGS="-j$(nproc)"|' /etc/makepkg.conf

# fix werid warnings
find /var/lib/pacman/local/ -type f -name "desc" -exec sed -i '/^%INSTALLED_DB%$/,+2d' {} \;
