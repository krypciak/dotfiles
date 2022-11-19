#!/bin/bash
function install_dwl() {
    echo 'meson ninja'
}

function configure_dwl() {
    cd $USER_HOME/.config/dwl/dwl-dotfiles/
    make
    
    cd $USER_HOME/.config/dwl/somebar/
    meson build
    cd $USER_HOME/.config/dwl/somebar/build
    ninja
}
