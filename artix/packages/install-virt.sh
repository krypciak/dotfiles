#!/bin/bash
function install_virt() {
    echo 'virt-manager qemu-desktop libvirt libvirt-openrc edk2-ovmf dnsmasq iptables-nft'
}

function configure_virt() {
    rc-update add libvirtd default
    cp $CONFIGD_DIR/root/etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf
    chown root:root /etc/libvirt/libvirtd.conf

    cp $CONFIGD_DIR/root/etc/libvirt/qemu.conf /etc/libvirt/qemu.conf
    sed -i "s/USER/$USER1/g" /etc/libvirt/qemu.conf
    chown root:root /etc/libvirt/qemu.conf

    usermod -aG libvirt $USER1
}

