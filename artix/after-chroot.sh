#!/bin/bash
export ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export USER_GROUP="$USER1"
export ISO="no"

source $ARTIXD_DIR/configure-inchroot-1.sh


source $ARTIXD_DIR/configure-inchroot-2.sh

source $ARTIXD_DIR/configure-inchroot-3.sh

pri "Enabling services"
paru -S networkmanager-openrc
rc-update add NetworkManager default


pri "Copying configs"
printf "$LBLUE"
cp -rv $CONFIGD_DIR/root/* /
printf "$NC"

source $ARTIXD_DIR/configure-inchroot-4.sh

paru --noconfirm -Scc > /dev/null 2>&1

pri "Configuring fstab"
ROOT_UUID=$(blkid $LVM_DIR/root -s UUID -o value)
ESCAPED_ROOT_UUID=$(printf '%s\n' "$ROOT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/ROOT_UUID/$ESCAPED_ROOT_UUID/g" /etc/fstab

SWAP_UUID=$(blkid $LVM_DIR/swap -s UUID -o value)
ESCAPED_SWAP_UUID=$(printf '%s\n' "$SWAP_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/SWAP_UUID/$ESCAPED_SWAP_UUID/g" /etc/fstab

HOME_UUID=$(blkid $LVM_DIR/home -s UUID -o value)
ESCAPED_HOME_UUID=$(printf '%s\n' "$HOME_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOME_UUID/$ESCAPED_HOME_UUID/g" /etc/fstab

BOOT_UUID=$(blkid $BOOT_PART -s UUID -o value)
ESCAPED_BOOT_UUID=$(printf '%s\n' "$BOOT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/BOOT_UUID/$ESCAPED_BOOT_UUID/g" /etc/fstab


ESCAPED_LVM_GROUP_NAME=$(printf '%s\n' "$LVM_GROUP_NAME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/LVM_GROUP_NAME/$ESCAPED_LVM_GROUP_NAME/g" /etc/fstab


ESCAPED_ROOT_FSTAB_ARGS=$(printf '%s\n' "$ROOT_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/ROOT_FSTAB_ARGS/$ESCAPED_ROOT_FSTAB_ARGS/g" /etc/fstab

ESCAPED_HOME_FSTAB_ARGS=$(printf '%s\n' "$HOME_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOME_FSTAB_ARGS/$ESCAPED_HOME_FSTAB_ARGS/g" /etc/fstab

ESCAPED_BOOT_FSTAB_ARGS=$(printf '%s\n' "$BOOT_FSTAB_ARGS" | sed -e 's/[\/&]/\\&/g')
sed -i "s/BOOT_FSTAB_ARGS/$ESCAPED_BOOT_FSTAB_ARGS/g" /etc/fstab

#ESCAPED_FAKE_USER_HOME=$(printf '%s\n' "$FAKE_USER_HOME" | sed -e 's/[\/&]/\\&/g')
#sed -i "s/FAKE_USER_HOME/$ESCAPED_FAKE_USER_HOME/g" /etc/fstab


pri "Generating mkinitcpio"
mkinitcpio -p $KERNEL


CRYPT_UUID=$(blkid $CRYPT_PART -s UUID -o value)
ESCAPED_CRYPT_UUID=$(printf '%s\n' "$CRYPT_UUID" | sed -e 's/[\/&]/\\&/g')
sed -i "s/CRYPT_UUID/$ESCAPED_CRYPT_UUID/g" /etc/default/grub

sed -i "s/SWAP_UUID/$ESCAPED_SWAP_UUID/g" /etc/default/grub

ESCAPED_CRYPT_NAME=$(printf '%s\n' "$CRYPT_NAME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/CRYPT_NAME/$ESCAPED_CRYPT_NAME/g" /etc/default/grub

sed -i "s/LVM_GROUP_NAME/$ESCAPED_LVM_GROUP_NAME/g" /etc/default/grub


pri "Installing grub to $BOOT_DIR_ALONE"
grub-install --target=x86_64-efi --efi-directory=$BOOT_DIR_ALONE --bootloader-id=$BOOTLOADER_ID

pri "Generating grub config"
grub-mkconfig -o /boot/grub/grub.cfg

neofetch

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi

