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
. "$DIR"/install-paru.sh
. "$DIR"/install-packages.sh
. "$DIR"/copy-configs.sh
. "$DOTDIR"/system-install/profile/common/scripts/temp-doas.sh
. "$DOTDIR"/system-install/profile/common/scripts/install-dotfiles.sh
. "$DOTDIR"/system-install/profile/common/scripts/set-passwords.sh
. "$DOTDIR"/system-install/profile/common/scripts/configure-packages.sh
. "$DOTDIR"/system-install/profile/common/scripts/cleanup.sh
. "$DIR"/mkinitcpio-toggle.sh enable

. "$DOTDIR"/system-install/profile/common/scripts/configure-fstab.sh
. "$DOTDIR"/system-install/profile/common/scripts/install-grub.sh
. "$DOTDIR"/system-install/profile/common/scripts/run-mkinitcpio.sh

# TODO: remember to uncheck checkspace in pacman.conf!

command -v 'neofetch' >/dev/null 2>&1 && neofetch

[ "$PAUSE_AFTER_DONE" = '1' ] && confirm 'Y shell ignore' "Confirm to continue" '' 'err "Said no to continuation prompt"; exit 1'
