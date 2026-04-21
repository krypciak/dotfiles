#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root

if [ "$1" = 'enable' ]; then
    if [ -f /90-mkinitcpio-install.hook ]; then
        info "Enabling mkinitcpio"
        mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
    fi
else
    if [ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook ]; then
        info "Disabling mkinitcpio"
        mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook
    fi
fi
