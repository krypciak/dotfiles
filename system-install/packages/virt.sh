#!/bin/bash

arch_virt_install() {
    echo 'dnsmasq edk2-ovmf iptables-nft libvirt qemu-desktop virt-manager'
}

_configure_qemu() {
    sed -i "s/USER/$USER1/g" /etc/libvirt/qemu.conf

    usermod -aG libvirt "$USER1"
}

arch_virt_configure() {
    _configure_qemu
    systemctl enable libvirtd.socket
}

