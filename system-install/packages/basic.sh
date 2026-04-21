#!/bin/sh

_configure_tldr() {
    info "tldr"
    # Generate tealdeer pages
    tldr --update
    tldr tldr >/dev/null 2>&1
    doas -u "$USER1" tldr --update
    doas -u "$USER1" tldr tldr >/dev/null 2>&1
}

arch_basic_install() {
    # TODO: there are some questionable choices here
    echo 'atuin autojump-rs-bin bat bat-extras bc bottom cage'
    echo 'clang dog dust dysk fd fish fzf htop hyperfine imagemagick'
    echo 'innoextract jq lazygit lsd man-db man-pages moreutils neofetch'
    echo 'neovim-symlinks net-tools nodejs ouch p7zip pastel'
    echo 'pipr-bin pnpm procs pv pyright ripgrep rmtrash syntax-highlighting'
    echo 'tealdeer tmux tokei trash-cli ttf-nerd-fonts-symbols ttyper'
    echo 'xorg-server-xvfb xorg-server-xvfb npm'
}

arch_basic_configure() {
    _configure_tldr
}
