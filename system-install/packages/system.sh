#!/bin/bash

_configure_greetd() {
    sed -i "s|USER_HOME|$USER_HOME|g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    cp -r "$USER_HOME/.config/xsessions" /etc/greetd/sessions
    chown "greeter:greeter" -R /etc/greetd
}

arch_system_install() {
    echo 'btrfs-progs clang dbus dbus dbus-glib dbus-python doas-sudo-shim'
    echo 'dosfstools efibootmgr git greetd grub mtools networkmanager'
    echo 'openbsd-netcat opendoas perl python python-pip'
    echo 'unrar unzip util-linux wget zip memtest86+'

    if [ "$INSTALL_PLYMOUTH_THEME" = '1' ]; then
        echo 'plymouth'
    fi
}

arch_system_configure() {
    _configure_greetd

    sed -i "s/USER1/$USER1/g" /etc/security/limits.conf

    systemctl enable greetd
    systemctl enable NetworkManager

    if [ "$TYPE" = 'iso' ]; then
        cp "$DOTDIR"/system-install/profile/iso/configs/arch-iso-service.service /usr/lib/systemd/system/
        cp "$DOTDIR"/system-install/profile/iso/configs/arch-iso-service.sh /etc/
        chmod +x /etc/arch-iso-service.sh
        systemctl enable arch-iso-service
        printf '\\S ISO \\r (\\l)' >/etc/issue
        printf '' >>/etc/issue
    else
        printf '\\S \\r (\\l)' >/etc/issue
        printf '' >>/etc/issue
    fi
}
