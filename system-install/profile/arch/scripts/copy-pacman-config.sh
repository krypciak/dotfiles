#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
export DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"
set -e

check_is_root
source_vars "$DOTDIR"

prefix="${1:-}"

pacmanconf_dest="$prefix/etc/pacman.conf"
pacmand_dest="$prefix/etc/pacman.d"

mkdir -p "$pacmand_dest"
cp -r "$DOTDIR"/system-install/profile/arch/root/etc/pacman.conf "$pacmanconf_dest"
cp -r "$DOTDIR"/system-install/profile/arch/root/etc/pacman.d/* "$pacmand_dest"

sed -i 's|CheckSpace|#CheckSpace|g' "$pacmanconf_dest"

if [ "$TYPE" = 'iso' ]; then
    # disable extracting unneccesary locales
    sed -i '/^#NoExtract *= */c\NoExtract = usr/share/locale/*\nNoExtract = !usr/share/locale/locale.alias\nNoExtract = !usr/share/locale/en*\nNoExtract = !usr/share/locale/pl*\nNoExtract = !usr/share/locale/ja*' "$pacmanconf_dest"
fi
