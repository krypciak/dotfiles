#!/bin/sh

arch_drivers_install() {
    echo 'mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers mkinitcpio-firmware'

    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'amd' ]; then echo "amd-ucode"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$CPU" = 'intel' ]; then echo "intel-ucode"; fi

    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'amd' ]; then
        # amdvlk lib32-amdvlk
        echo "xf86-video-amdgpu amdvlk lib32-amdvlk vulkan-radeon lib32-vulkan-radeon"
        # cp $COMMON_CONFIGS_DIR/20-amdgpu.conf /etc/X11/xorg.conf.d/
    fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'ati' ]; then echo "xf86-video-ati amdvlk lib32-amdvlk vulkan-radeon lib32-vulkan-radeon"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'intel' ]; then echo "xf86-video-intel vulkan-intel lib32-vulkan-intel"; fi
    if [ "$ALL_DRIVERS" = '1' ] || [ "$GPU" = 'nvidia' ]; then echo "xf86-video-nouveau"; fi

    echo $DRIVER_LIST
}
