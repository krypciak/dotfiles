#!/bin/sh

arch_base_install() {
    echo "$KERNEL $KERNEL-headers"

    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'amd' ]; then echo "amd-ucode"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'intel' ]; then echo "intel-ucode"; fi

    echo 'archlinux-keyring autoconf automake base bash bison bzip2 coreutils'
    echo 'fakeroot file filesystem findutils flex gawk gcc gcc-libs gettext glibc grep'
    echo 'groff gzip  iproute2 iptables-nft iputils libtool licenses linux-firmware'
    echo 'lvm2 m4 make mkinitcpio openbsd-netcat opendoas openntpd pacman patch pciutils'
    echo 'pkgconf procps-ng psmisc sed shadow systemd tar texinfo util-linux which xz'
}
