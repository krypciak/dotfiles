#!/bin/bash

arch_basic_install() {
    # already in system
    echo 'git zip wget unzip unrar'

    echo 'fish lsd fd dysk dust atuin autojump-rs-bin ouch'
    echo 'tealdeer fastfetch bat bat-extras htop bottom hyperfine'
    echo 'bc jq tmux fzf'
    echo 'neovim neovim-symlinks tree-sitter-cli'
    echo 'lazygit tokei ttyper'
    echo 'ttf-nerd-fonts-symbols ttf-dejavu ttf-hack'
    echo 'man-db man-pages'
    echo 'imagemagick innoextract net-tools p7zip moreutils'
    echo 'procs'
    echo 'trash-cli'
}

_configure_tldr() {
    info "tldr"
    # Generate tealdeer pages
    tldr --update
    tldr tldr >/dev/null 2>&1
    doas -u "$USER1" tldr --update
    doas -u "$USER1" tldr tldr >/dev/null 2>&1
}

arch_basic_configure() {
    _configure_tldr
}
