#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

if [ -z "$GROUP_LIST" ]; then
    . "$DOTDIR"/system-install/profile/common/scripts/gather-package-list.sh
fi

info_garr "Configuring packages"

for group in $PACKAGE_GROUPS; do
    . "$DB"/packages/"$group".sh
    CONFIG_FUNC="${VARIANT}_${group}_configure"
    if command -v "$CONFIG_FUNC" > /dev/null 2>&1; then
        info_barr "Configuring <user>$group</user>"
        eval "$CONFIG_FUNC"
    fi
done

