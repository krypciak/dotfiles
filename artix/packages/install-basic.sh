#!/bin/sh
function install_basic() {
    echo 'dbus dbus-openrc dbus-python dbus-glib fzf perl python rmtrash trash-cli ttf-dejavu ttf-hack python-pip htop autojump git neofetch neovim-symlinks ranger syntax-highlighting tldr util-linux wget lsd dos2unix p7zip unrar unzip zip mandoc greetd-artix-openrc greetd-tuigreet-bin opendoas-sudo nvim-packer-git'
}

function configure_basic() {
    pri "Configuring greetd"
    ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')
    sed -i "s/USER_HOME/${ESCAPED_USER_HOME}/g" /etc/greetd/config.toml
    sed -i "s/USER1/${USER1}/g" /etc/greetd/config.toml
    chown greeter:greeter /etc/greetd/config.toml
    rc-update add greetd default
    rc-update del agetty.tty1 default
}

#world/libsamplerate world/freetype2 world/libglvnd world/libogg world/flac world/pipewire-jack world/sbc world/libldac world/libfreeaptx galaxy/libfdk-aac galaxy/lilv galaxy/serd galaxy/sord galaxy/sratom world/webrtc-audio-processing world/libass world/libbluray world/dav1d world/rav1e world/librsvg world/libva world/vid.stab world/libvpx world/x264 world/l-smash world/x265 world/xvidcore world/zimg world/mailcap lib32/lib32-freetype2 lib32/lib32-libglvnd lib32/lib32-dbus world/geoclue world/wolfssl world/gnome-keyring lsd keepassxc copyq world/xorg-xmodmap redshift galaxy/strawberry scrot playerctl nvim-packer-git bluez bluez-utils galaxy/python-typing_extensions python-pip 
