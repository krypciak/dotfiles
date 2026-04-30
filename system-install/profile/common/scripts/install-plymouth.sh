#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

if [ "$INSTALL_PLYMOUTH_THEME" = 1 ]; then
    info_garr "Configuring plymouth"

    info_barr "Installing crosscode plymouth theme"
    git clone https://github.com/krypciak/crosscode-plymouth /tmp/crosscode-plymouth
    bash /tmp/crosscode-plymouth/install.sh

    info_barr "Adding kernel flags to grub"
    flags="quiet splash vt.global_cursor_default=0 loglevel=3 systemd.show_status=0 rd.udev.log_level=3 fbcon=nodefer"
    sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"|\0 ${flags}|g" /etc/default/grub

    if ! grep -qw "plymouth" /etc/mkinitcpio.conf; then
        sed -i 's|udev|\0 plymouth|g' /etc/mkinitcpio.conf
    fi
fi
