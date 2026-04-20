#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

# . "$DIR"/time-lang.sh
. "$DOTDIR"/system-install/profile/common/scripts/add-user.sh
. "$DOTDIR"/system-install/profile/common/scripts/temp-doas.sh
. "$DIR"/init-pacman.sh
. "$DIR"/install-paru.sh

# if [ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook ]; then
#     info "Disabling mkinitcpio"
#     mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook
# fi

# TODO: remember to uncheck checkspace in pacman.conf!

info 'All done'
