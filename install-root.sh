#!/bin/sh
set -e

DIR="$(printf "$(dirname $0)" | xargs realpath)"
cd "$DIR"

. ./util.sh

check_is_root

_help() {
    printf "Usage:\n"
    printf "    -h --help       Displays this message\n"
    printf "    -y --noconfim   Skips confirmations\n"
    exit 1
}
handle_args '-y|--noconfirm=export YOLO=1' "$@"

info_garr "Installing dotfiles for root..."

info_garr "Copying configuration files..."

export USER_HOME='/root'

inst copy .config/nvim
inst copy .config/fish
inst copy .bashrc
inst copy .config/at-login.sh
inst copy .config/aliases.sh

# Update nvim plugins if there is internet
if slient_err nc -z 8.8.8.8 53 -w 1; then
    info_barr 'Updating neovim plugins...'
    timeout 20s nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
fi
info 'Done'
