#!/bin/sh

artix_base_install() {
    echo "$KERNEL $KERNEL-headers"
    echo 'amd-ucode artix-keyring artix-mirrorlist autoconf automake base bison elogind-openrc fakeroot flex gcc groff intel-ucode iptables-nft libtool linux-firmware lvm2 m4 make memtest86+ mkinitcpio openbsd-netcat opendoas openntpd-openrc openrc pacman patch pkgconf texinfo util-linux which'
}

arch_base_install() {
    echo "$KERNEL $KERNEL-headers"
    echo 'amd-ucode archlinux-keyring autoconf automake base bash bison bzip2 coreutils fakeroot file filesystem findutils flex gawk gcc gcc-libs gettext glibc grep groff gzip intel-ucode iproute2 iptables-nft iputils libtool licenses linux-firmware lvm2 m4 make memtest86+ mkinitcpio openbsd-netcat opendoas openntpd pacman patch pciutils pkgconf procps-ng psmisc sed shadow systemd tar texinfo util-linux which xz'
}
