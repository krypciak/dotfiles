#!/bin/bash
function install_dwl() {
    echo 'meson ninja'
}

function configure_dwl() {
    cd $USER_HOME/.config/dwl/dwl-dotfiles/
    doas -u $USER1 make
    
    cd $USER_HOME/.config/dwl/somebar/
    doas -u $USER1 meson build
    cd $USER_HOME/.config/dwl/somebar/build
    doas -u $USER1 ninja

    cd $USER_HOME/.config/dwl/dpms-off
    doas -u $USER1 cargo build --release

    cd $USER_HOME/.config/dwl/someblocks
    doas -u $USER1 make
}
