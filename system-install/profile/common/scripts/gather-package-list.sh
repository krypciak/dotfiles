#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

source_vars "$DOTDIR"

info "Gathering package list"

PACKAGE_LIST=''
GROUP_LIST=''
for group in $PACKAGE_GROUPS; do
    . "$DOTDIR"/system-install/packages/"$group".sh
    INSTALL_FUNC="${OS_VARIANT}_${group}_install"
    if command -v "$INSTALL_FUNC" >/dev/null 2>&1; then
        GROUP_LIST="$GROUP_LIST $group"
        PACKAGE_LIST="$PACKAGE_LIST $($INSTALL_FUNC | xargs) "
    fi
done
export PACKAGE_LIST
export GROUP_LIST
