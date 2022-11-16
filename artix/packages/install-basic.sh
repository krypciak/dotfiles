#!/bin/sh
function install_basic() {
    echo 'dbus dbus-openrc dbus-python dbus-glib fzf perl python rmtrash trash-cli ttf-dejavu ttf-hack python-pip htop autojump git neofetch neovim-symlinks ranger syntax-highlighting tldr util-linux wget lsd dos2unix p7zip unrar unzip zip mandoc greetd-artix-openrc greetd-tuigreet-bin opendoas-sudo nvim-packer-git'
}

function configure_basic() {
    pri "Configuring greetd"
    sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    chown greeter:greeter /etc/greetd/config.toml
    rc-update add greetd default
    rc-update del agetty.tty1 default
}
