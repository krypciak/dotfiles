#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

chown_user "$USER_HOME"

if [ "$INSTALL_DOTFILES" = '1' ]; then
    info "Installing dotfiles for user <user>$USER1</user>"
    doas -u "$USER1" sh "$DOTDIR"/install-dotfiles.sh

    info_barr 'Downloading user neovim plugins etc...'
    doas -u "$USER1" ./"$DOTDIR"/system-install/profile/common/scripts/nvim-preinstall.sh

    mkdir -p /root/.local/share
    if [ "$TYPE" = 'iso' ]; then
        if [ -d /root/.local/share/nvim ]; then
            rm -rf /root/.local/share/nvim
        fi
        ln -s "$USER_HOME"/.local/share/nvim /root/.local/share/nvim
    else
        cp -r "$USER_HOME"/.local/share/nvim /root/.local/share/nvim
        chown_root /root/.local/share/nvim
    fi

    info "Installing dotfiles for <user>root</user>"
    sh "$DOTDIR"/install-dotfiles.sh --root

    info_barr 'Downloading user neovim plugins etc...'
    ./"$DOTDIR"/system-install/profile/common/scripts/nvim-preinstall.sh 10000

    chown_user "$USER_HOME"/.local/share/nvim
fi

info 'Generating fish completions'
fish --command "fish_update_completions" >/dev/null 2>&1 &
doas -u "$USER1" fish --command "fish_update_completions" >/dev/null 2>&1 &

wait $(jobs -p)
