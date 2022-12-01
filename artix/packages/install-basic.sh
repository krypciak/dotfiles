#!/bin/sh
function install_basic() {
    echo 'dbus dbus-openrc dbus-python dbus-glib fzf perl python rmtrash trash-cli ttf-dejavu ttf-hack python-pip htop autojump git neofetch neovim-symlinks ranger syntax-highlighting tldr util-linux wget lsd dos2unix p7zip unrar unzip zip mandoc greetd-artix-openrc greetd-tuigreet-bin opendoas-sudo nvim-packer-git net-tools fish opendoas efibootmgr grub tree dosfstools mtools tmux galaxy/ttf-nerd-fonts-symbols-2048-em util-linux atuin'
}

function configure_basic() {
    pri "Configuring greetd"
    sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    chown greeter:greeter /etc/greetd/config.toml
    rc-update add greetd default
    rc-update del agetty.tty1 default
}
