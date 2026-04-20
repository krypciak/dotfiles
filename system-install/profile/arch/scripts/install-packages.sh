#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1

. "$DB"/profile/"$VARIANT"/scripts/init-keyring.sh
. "$DB"/profile/"$VARIANT"/scripts/install-base.sh
. "$DB"/profile/"$VARIANT"/scripts/install-paru.sh

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

# hack to get doas-sudo-shim installed
rm -f /usr/bin/sudo

info "Installing groups: <user>$GROUP_LIST</user>"

if [ "$NET" = 'offline' ]; then
    if ! cd "$USER_HOME"/home/.config/repohub/distrobridge/packages/offline/"$VARIANT"/packages; then
        err "Offline packages dir for variant <user>$VARIANT</user> missing."
        exit 1
    fi
    # shellcheck disable=SC2010
    pacman --noconfirm --needed -U $(ls -1 -- *.pkg.tar.zst | grep -E -e $(echo $PACKAGE_LIST | tr ' ' '\n' | awk '{print "-e ^" $1 "-[[:digit:]]"}' | xargs)) 2> /dev/stdout | grep -v 'skipping' > $OUTPUT 2>&1
else
    n=0
    until [ "$n" -ge 5 ]; do
        doas -u "$USER1" paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST > $OUTPUT 2>&1 && break
        n=$((n+1))
        err "Package installation failed. Attempt $n/3"
        sleep 3
    done
    if [ "$n" -eq 3 ]; then err "Package installation failed."; sh; exit 1; fi
fi

