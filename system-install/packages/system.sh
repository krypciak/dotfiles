#!/bin/sh

_configure_greetd() {
    sed -i "s|USER_HOME|$USER_HOME|g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    cp -r "$USER_HOME/.config/xsessions" /etc/greetd/sessions
    chown "greeter:greeter" -R /etc/greetd
}

arch_system_install() {
    echo 'btrfs-progs clang dbus dbus dbus-glib dbus-python doas-sudo-shim'
    echo 'dosfstools efibootmgr git greetd grub mtools networkmanager'
    echo 'openbsd-netcat opendoas perl python python-pip ttf-dejavu ttf-hack'
    echo 'unrar unzip util-linux wget zip'
}

arch_system_configure() {
    _configure_greetd

    sed -i "s/USER1/$USER1/g" /etc/security/limits.conf

    systemctl enable greetd
    systemctl enable NetworkManager

    # TODO: iso
    if [ "$TYPE" = 'iso' ]; then
        cp "$DB"/profile/iso/configs/arch-iso-net.service /usr/lib/systemd/system/
        cp "$DB"/profile/iso/configs/arch-artix-net.sh /etc/
        chmod +x /etc/arch-artix-net.sh
        systemctl enable arch-iso-net
    fi
}
