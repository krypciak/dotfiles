#!/bin/bash
set -e

DOTDIR="$(printf "$(dirname $0)" | xargs realpath)"
. "$DOTDIR"/util.sh
cd "$DOTDIR"

_help() {
    printf "Usage:\n"
    printf "    -h --help       Displays this message\n"
    printf "    -y --noconfim   Skips confirmations\n"
    printf "    -r --root       Install for root\n"
    exit 0
}
handle_args "\
-y|--noconfirm=export YOLO=1,\
-r|--root=export FOR_ROOT=1,\
" "$@"

inst() {
    method="$1" # copy or link
    path="$2"
    override="$3"
    _continue=0

    from="$(realpath "./user/$path")"
    dest="$USER_HOME/$path"

    if [ -h "$dest" ]; then unlink "$dest"; fi
    if [ -e "$dest" ]; then
        if [ "$override" == 'nooverride' ]; then
            warn "<path>$path</path> exists, skipping"
            return
        fi
        [ "$YOLO" -eq 0 ] && confirm 'Y barr' "Do you want to override <path>${dest}</path> ?" "rm -rf $dest" 'export _continue=1'
        [ "$_continue" = 1 ] && return
    fi

    mkdir -p "$(dirname "$dest" | head --lines 1)"
    if [ "$method" = 'copy' ]; then
        info_barr "Copying <path>$path</path> to <path>$dest</path>"
        cp -rf "$from" "$dest"
    else
        info_barr "Linking <path>$path</path> to <path>$dest</path>"
        ln -sfT "$from" "$dest"
    fi
    chown_user "$dest"
}

# info "Updating submodules..."
# git submodule update --init --recursive

if [ "$FOR_ROOT" != "1" ]; then
    check_isnt_root

    info "Installing dotfiles for user..."

    info_garr "Linking configuration files..."

    inst link .config/at-login.sh
    inst link .config/aliases.sh
    inst link .config/scripts
    inst link .config/nvim
    inst link .config/zed
    inst link .zshrc
    inst link .config/zsh
    inst link .config/fish
    inst link .config/tealdeer
    inst link .bashrc
    inst link .bash_profile
    inst link .config/xsessions
    inst link .config/neofetch
    inst link .config/topgrade.toml
    inst link .config/ttyper
    inst link .config/animdl
    inst link .config/mimeapps.list
    inst link .config/atuin
    inst link .shellcheckrc
    inst link .config/gdb
    inst link .config/lazygit/config.yml

    inst link .config/alacritty
    inst link .config/wallpapers
    inst link .config/cmus/red_theme.theme
    inst link .config/cmus/notify.cfg
    inst link .config/safeeyes
    inst link .config/fcitx5

    inst link .config/awesome
    inst link .config/redshift
    inst link .config/rofi

    inst link .config/dwl
    inst link .config/river
    inst link .config/gammastep
    inst link .config/fuzzel
    inst link .config/swaylock
    inst link .config/fnott
    inst link .config/hypr
    inst link .config/waybar

    inst link .config/WebCord/config.json

    inst link .config/tridactyl

    inst link .config/krunnerrc
    inst link .config/plasmarc
    inst link .config/plasmashellrc

    info_garr "Copying configuration files..."

    inst copy .config/gtk-3.0 nooverride
    inst copy .config/qt5ct nooverride
    inst copy .config/qt6ct nooverride

    inst copy .config/tutanota-desktop/conf.json nooverride
    inst copy .config/cmus/autosave nooverride

    inst copy .config/keepassxc nooverride

    inst copy .local/share/applications/tutanota-desktop.desktop nooverride

    inst copy .config/chromium-flags.conf nooverride

    inst copy .local/share/PrismLauncher/multimc.cfg nooverride
    path="$USER_HOME"/.local/share/PrismLauncher/multimc.cfg
    if [ -f "$path" ]; then
        sed -i "s|USER_HOME|$USER_HOME|g" "$path"
        sed -i "s|HOSTNAME|$(uname -n)|g" "$path"
    fi

    chmod +x "$USER_HOME"/.config/awesome/run/run.sh
    chmod +x "$USER_HOME"/.config/scripts/*.sh
    chmod +x "$USER_HOME"/.config/scripts/copy
    chmod +x "$USER_HOME"/.config/scripts/pst
else
    check_is_root
    export USER1='/root'
    export USER_HOME='/root'

    info_garr "Installing dotfiles for root..."

    info_garr "Copying configuration files..."

    inst copy .config/nvim
    inst copy .config/fish
    inst copy .bashrc
    inst copy .config/at-login.sh
    inst copy .config/aliases.sh
fi

chmod +x "$USER_HOME"/.config/at-login.sh
chmod +x "$USER_HOME"/.config/aliases.sh

# Update nvim plugins if there is internet
if slient_err nc -z 8.8.8.8 53 -w 1; then
    info_barr 'Updating neovim plugins...'
    timeout 20s nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
fi
info 'Done'
