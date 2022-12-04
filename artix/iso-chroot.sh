#!/bin/bash
export ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export USER_GROUP='1001'
export ISO="yes"

source "$ARTIXD_DIR/iso-vars.sh"
source $ARTIXD_DIR/configure-inchroot-1.sh

pacman-key --init
pacman-key --populate artix

sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
source $ARTIXD_DIR/configure-inchroot-2.sh

DOTFILES_DIR=$USER_HOME/home/.config/dotfiles
pri "Copying the repo to $DOTFILES_DIR"
mkdir -p $DOTFILES_DIR/..
cp -rf $ARTIXD_DIR/../ $DOTFILES_DIR/

printf "3\n2\n" > $DOTFILES_DIR/dotfiles/wallpapers/selected


export ARTIXD_DIR=$DOTFILES_DIR/artix
export CONFIGD_DIR=$DOTFILES_DIR/config-files

source $ARTIXD_DIR/configure-inchroot-3.sh


# install icecat
cd $USER_HOME/.cache/paru/clone/icecat
chown $USER1:1001 -R $USER_HOME/.cache/paru/clone/icecat
doas -u $USER1 makepkg -sie --noconfirm
cd /


pri "Copying configs"
printf "$LBLUE"
rsync -av --progress $CONFIGD_DIR/root/ / --exclude etc/fstab --exclude etc/pacman.conf --exclude etc/default/grub --exclude etc/doas.conf --exclude etc/pacman.d --exclude etc/mkinitcpio.conf
printf "$NC"

source $ARTIXD_DIR/configure-inchroot-4.sh

sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/artools/artools-base.conf

echo "permit setenv { XAUTHORITY LANG LC_ALL } nopass root" > /etc/doas.conf
echo "permit setenv { XAUTHORITY LANG LC_ALL } nopass :wheel" >> /etc/doas.conf
echo "permit setenv { XAUTHORITY LANG LC_ALL } nopass $USER1\n" >> /etc/doas.conf


printf "\
local swapdev \n\
swapdev=\"\$(fdisk -l 2>/dev/null | grep swap | cut -d' ' -f1)\" \n\
if [ -e \"\$(swapdev)\" ]; then \n\
    swapon \"\$(swapdev)\" \n\
fi \n\
usermod -ag tty,ftp,games,network,scanner,users,video,audio,wheel,libvirt $user1 \n\
" > /bin/artix-live

sed -i -E ':a;N;$!ba;s/configure_user\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/configure_language\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/configure_displaymanager\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/detect_desktop_env\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/configure\n//g' /bin/artix-live
echo "usermod -aG tty,ftp,games,network,scanner,users,video,audio,wheel,libvirt $USER1" >> /bin/artix-live
#echo "chown $USER1:$USER_GROUP -R /home/$USER1/" >> /bin/artix-live



rc-update del agetty.tty2 default
rc-update del agetty.tty3 default
rc-update del agetty.tty4 default
rc-update del agetty.tty5 default
rc-update del agetty.tty6 default

pri "Cleaning up (iso)"
umount /var/cache/pacman/pkg
umount $USER_HOME/.cache/paru/clone
umount $USER_HOME/.cargo
rm /after-chroot.sh -f

neofetch

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi

