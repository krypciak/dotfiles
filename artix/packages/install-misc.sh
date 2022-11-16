#!/bin/bash
function install_misc() {
    echo 'artools iso-profiles libreoffice-fresh cups-openrc'
}

function configure_misc() {
    rc-update add cupsd default

    sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/artools/artools-base.conf
}


