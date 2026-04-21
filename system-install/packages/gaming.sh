#!/bin/sh

arch_gaming_install() {
    arch_java_install
    echo 'alsa-lib alsa-plugins gamemode gamescope giflib gnutls gst-plugins-base-libs'
    echo 'lib32-alsa-lib lib32-alsa-plugins lib32-gamemode lib32-giflib lib32-giflib lib32-gnutls'
    echo 'lib32-gst-plugins-base-libs lib32-gtk3 lib32-libgcrypt lib32-libgpg-error lib32-libjpeg-turbo'
    echo 'lib32-libldap lib32-libpng lib32-libpulse lib32-libpulse lib32-libva lib32-libxcomposite'
    echo 'lib32-libxcomposite lib32-libxinerama lib32-libxinerama lib32-libxslt lib32-mpg123'
    echo 'lib32-ncurses lib32-ocl-icd lib32-openal lib32-openal lib32-opencl-icd-loader lib32-sqlite'
    echo 'lib32-v4l-utils lib32-v4l-utils lib32-vulkan-icd-loader libgcrypt libgpg-error libjpeg-turbo'
    echo 'libldap libpng libpulse libva libxcomposite libxinerama libxslt mpg123 ncurses ocl-icd openal'
    echo 'sqlite v4l-utils vulkan-icd-loader'
    echo 'wine-staging'
    echo 'obs-studio prismlauncher steam '
}
