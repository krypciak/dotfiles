#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Installing paru (AUR manager)"

if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi

# If paru is already installed, skip this step
if ! command -v "paru" >/dev/null 2>&1; then
    pacman $PACMAN_ARGUMENTS -Sy git doas debugedit
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    chown_user /tmp/paru
    chmod -R +wrx /tmp/paru
    cd /tmp/paru || exit 1
    doas -u "$USER1" makepkg -si --noconfirm --needed
fi
cp "$DOTDIR"/system-install/profile/arch/root/etc/paru.conf /etc/paru.conf
