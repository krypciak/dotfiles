#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

. "$DIR"/mkinitcpio-toggle.sh disable
. "$DIR"/time-lang.sh
. "$DOTDIR"/system-install/profile/common/scripts/add-user.sh
. "$DOTDIR"/system-install/profile/common/scripts/temp-doas.sh
. "$DIR"/init-pacman.sh
. "$DIR"/cachy-repos.sh
. "$DIR"/install-paru.sh


. "$DIR"/mkinitcpio-toggle.sh enable
# TODO: remember to uncheck checkspace in pacman.conf!

info 'All done'
