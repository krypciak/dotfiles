#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

if [[ ! -v GROUP_LIST ]]; then
    . "$DOTDIR"/system-install/profile/common/scripts/gather-package-list.sh
fi

info "Installing groups: <user>$GROUP_LIST</user>"

n=0
until [ "$n" -ge $PACKAGE_INSTALL_ATTEMPTS ]; do
    doas -u "$USER1" paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST && break
    n=$((n + 1))
    err "Package installation failed. Attempt $n/$PACKAGE_INSTALL_ATTEMPTS"
    sleep 3
done
if [ "$n" -eq $PACKAGE_INSTALL_ATTEMPTS ]; then
    err "Package installation failed."
    exit 1
fi
