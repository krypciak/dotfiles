#!/bin/bash

arch_gaming_install() {
    arch_java_install
    echo 'alsa-lib alsa-plugins gamemode gamescope giflib gnutls gst-plugins-base-libs'
    echo 'libgcrypt libgpg-error libjpeg-turbo'
    echo 'libldap libpng libpulse libva libxcomposite libxinerama libxslt mpg123 ncurses ocl-icd openal'
    echo 'sqlite v4l-utils vulkan-icd-loader'
    echo 'wine-staging'
    echo 'obs-studio prismlauncher steam'
}
