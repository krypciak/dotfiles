#!/bin/bash

arch_drivers_install() {
    echo 'mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers'

    if [ "$ALL_DRIVERS" = '1' ]; then
        echo 'linux-firmware mkinitcpio-firmware'
    else
        echo "$LINUX_FIRMWARE_PACKAGES"
    fi

    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'amd' ]; then echo "amd-ucode"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'intel' ]; then echo "intel-ucode"; fi

    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'amd' ]; then
        echo "xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon linux-firmware-amdgpu"
        # cp $COMMON_CONFIGS_DIR/20-amdgpu.conf /etc/X11/xorg.conf.d/
    fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'ati' ]; then echo "xf86-video-ati vulkan-radeon lib32-vulkan-radeon linux-firmware-radeon"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'intel' ]; then echo "xf86-video-intel vulkan-intel lib32-vulkan-intel linux-firmware-intel"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'nvidia' ]; then echo "xf86-video-nouveau linux-firmware-nvidia"; fi
}
