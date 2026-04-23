#!/bin/bash

arch_strap_install() {
    echo "$KERNEL $KERNEL-headers"

    echo 'archlinux-keyring cachyos-keyring pacman'
    echo 'autoconf automake base bash bison bzip2 coreutils'
    echo 'fakeroot file filesystem findutils flex gawk gcc gcc-libs gettext glibc grep'
    echo 'groff gzip  iproute2 iptables-nft iputils libtool licenses'
    echo 'lvm2 m4 make mkinitcpio openbsd-netcat opendoas openntpd patch pciutils'
    echo 'pkgconf procps-ng psmisc sed shadow systemd tar texinfo util-linux which xz'
}
