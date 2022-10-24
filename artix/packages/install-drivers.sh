#!/bin/bash
function install_drivers() {
    PACKAGES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    source "$PACKAGES_DIR/../vars.sh"
    
    DRIVER_LIST='mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers mkinitcpio-firmware '

    if [ $ALL_DRIVERS -eq 0 ]; then
        if [ "$CPU" == 'amd' ]; then DRIVER_LIST="$DRIVER_LIST amd-ucode"
        elif [ "$CPU" == 'intel' ]; then DRIVER_LIST="$DRIVER_LIST intel-ucode"
        else confirm "Invalid CPU: $CPU" "ignore"; fi
    
        if [ "$GPU" == 'amd' ]; then 
            DRIVER_LIST="$DRIVER_LIST xf86-video-amdgpu amdvlk lib32-amdvlk vulkan-radeon lib32-vulkan-radeon"
            cp $PACKAGES_DIR/../../config-files/20-amdgpu.conf /etc/X11/xorg.conf.d/
        elif [ "$GPU" == 'ati' ]; then DRIVER_LIST="$DRIVER_LIST xf86-video-ati amdvlk lib32-amdvlk vulkan-radeon lib32-vulkan-radeon"
        elif [ "$GPU" == 'intel' ]; then DRIVER_LIST="$DRIVER_LIST xf86-video-intel vulkan-intel lib32-vulkan-intel"
        elif [ "$GPU" == 'nvidia' ]; then DRIVER_LIST="$DRIVER_LIST xf86-video-nouveau nvidia-utils"
        else confirm "Invalid GPU: $GPU" "ignore"; fi
    
    elif [ $ALL_DRIVERS -eq 1 ]; then
        DRIVER_LIST="$DRIVER_LIST amd-ucode intel-ucode"
        DRIVER_LIST="$DRIVER_LIST xf86-input-vmmouse xf86-video-amdgpu xf86-video-ati xf86-video-dummy xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-openchrome xf86-video-sisusb xf86-video-vesa xf86-video-vmware xf86-video-voodoo"
        #DRIVER_LIST="$DRIVER_LIST $(pacman -Sqs vulkan | grep vulkan)"
    fi
    echo $DRIVER_LIST
}
