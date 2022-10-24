#!/bin/bash

ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR=$ARTIXD_DIR/..
CONFIGD_DIR=$DOTFILES_DIR/config-files

source "$ARTIXD_DIR/vars.sh"
export PACMAN_ARGUMENTS
export PARU_ARGUMENTS
export YOLO
export USER1
export PRIVATE_DOTFILES_PASSWORD

pri "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

pri "Generating locale"
cp $CONFIGD_DIR/root/etc/locale.gen /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LANG
export LC_COLLATE="C"

pri "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname=\'$HOSTNAME\'" > /etc/conf.d/hostname


sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf



confirm "Install base packages?"
pacman -Sy
n=0
until [ "$n" -ge 5 ]; do
    pacman $PACMAN_ARGUMENTS -S lvm2 cryptsetup mkinitcpio grub efibootmgr dosfstools freetype2 fuse2 mtools device-mapper-openrc lvm2-openrc cryptsetup-openrc networkmanager-openrc git neovim neofetch wget fish linux-firmware $KERNEL $KERNEL-headers opendoas mkinitcpio world/rust btrfs-progs tree galaxy/ttf-nerd-fonts-symbols-2048-em tmux && break
    n=$((n+1))
done
if [ "$n" -eq 5 ]; then pri "${RED}ERROR. Exiting..."; exit; fi


pri "Updating keyring"
# Disable package signature verification
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/g' /etc/pacman.conf
sed -i 's/LocalFileSigLevel = Optional/#LocalFileSigLevel = Optional/g' /etc/pacman.conf
# Add lib32 repo
printf '[lib32]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
# Add universe repo
printf '[universe]\nServer = https://universe.artixlinux.org/$arch\nServer = https://mirror1.artixlinux.org/universe/$arch\nServer = https://mirror.pascalpuffke.de/artix-universe/$arch\nServer = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch\nServer = https://mirror1.cl.netactuate.com/artix/universe/$arch\nServer = https://ftp.crifo.org/artix-universe/\n' >> /etc/pacman.conf

PACKAGES_LIST='artix-archlinux-support '
if [ $LIB32 -eq 1 ]; then
    PACKAGES_LIST="$PACKAGES_LIST lib32-artix-archlinux-support"
fi
pacman $PACMAN_ARGUMENTS -Sy $PACKAGES_LIST
pacman-key --init
pacman-key --populate

pri "Copying pacman configuration"
cp $CONFIGD_DIR/root/etc/pacman.conf /etc/pacman.conf
cp -r $CONFIGD_DIR/root/etc/pacman.d /etc/
pacman -Sy 


pri "Adding user $USER1"
if ! id "$USER1" &>/dev/null; then
    useradd -s /bin/bash -G tty,ftp,games,network,scanner,users,video,audio,wheel $USER1
    chown -R $USER1:$USER1 $USER_HOME/
    chown -R $USER1:$USER1 $ARTIXD_DIR
fi

pri "Creating temporary doas config"
echo "permit nopass setenv { YOLO USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS } root" > /etc/doas.conf
echo "permit nopass setenv { YOLO USER1 PACMAN_ARGUMENTS PARU_ARGUMENTS } $USER1" >> /etc/doas.conf

sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/' /etc/makepkg.conf

pri "Installing paru (AUR manager)"
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi
# If paru is already installed, skip this step
if ! command -v "paru"; then
    pacman $PACMAN_ARGUMENTS -S git
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
    chown -R $USER1:$USER1 /tmp/paru
    chmod +wrx /tmp/paru
    cd /tmp/paru
    doas -u $USER1 makepkg -si --noconfirm --needed
fi
cp $CONFIGD_DIR/root/etc/paru.conf /etc/paru.conf

pri "Disabling mkinitcpio"
mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook 
#sed -i '1s/^/exit\n/' $INSTALL_DIR/bin/mkinitcpio

confirm "Install packages?"
doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S opendoas-sudo nvim-packer-git greetd-artix-openrc greetd-tuigreet-bin
PACKAGE_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    source $ARTIXD_DIR/packages/install-${group}.sh
    pri "Installing $group"
    PACKAGE_LIST="$PACKAGE_LIST $(install_${group}) "
done

n=0
until [ "$n" -ge 5 ]; do
    doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST && break
    n=$((n+1))
done
if [ "$n" -eq 5 ]; then pri "${RED}ERROR. Exiting..."; exit; fi

for group in "${PACKAGE_GROUPS[@]}"; do
    CONFIG_FUNC="configure_$group"
    if command -v "$CONFIG_FUNC" &> /dev/null; then
        pri "Configuring $group"
        eval "$CONFIG_FUNC"
    fi
done



pri "Enabling services"
rc-update add NetworkManager default
#rc-update add device-mapper boot
#rc-update add lvm boot
#rc-update add dmcrypt boot


if [ $INSTALL_DOTFILES -eq 1 ]; then
    pri "Installing dotfiles for user $USER1"
    rm -rf $USER_HOME/.config
    doas -u $USER1 sh $DOTFILES_DIR/install-dotfiles.sh

    pri "Installing dotfiles for root"
    sh $DOTFILES_DIR/install-dotfiles-root.sh


    if [ $INSTALL_PRIVATE_DOTFILES -eq 1 ]; then
        confirm "Install private dotfiles?"
        export GPG_AGENT_INFO=""
        sh $DOTFILES_DIR/decrypt-private-data.sh
    fi
fi

fish --command "fish_update_completions"
doas -u $USER1 fish --command "fish_update_completions"

pri "Cleaning up"
rm -rf $USER_HOME/.cargo
#find /var/cache/pacman/pkg/ -iname "*.part" -delete
paru --noconfirm -Scc > /dev/null 2>&1

pri "Copying configs"
printf "$LBLUE"
cp -rv $CONFIGD_DIR/root/* /
printf "$NC"

if [ $AWESOME_START_TUTANOTA -eq 0 ]; then
    ESCAPED_T1=$(printf '%s\n' "run_if_not_running_pgrep({ \"tutanota\" }" | sed -e 's/[\/&]/\\&/g')
    sed -i "s/$ESCAPED_T1/--$ESCAPED_T1/g" $USER_HOME/.config/awesome/after_5sec.lua
fi
if [ $AWESOME_START_CMUS -eq 0 ]; then
    ESCAPED_T1=$(printf '%s\n' "run_if_not_running_pgrep({ music_player_class }" | sed -e 's/[\/&]/\\&/g')
    sed -i "s/$ESCAPED_T1/--$ESCAPED_T1/g" $USER_HOME/.config/awesome/autostart.lua
fi

chmod -rw /etc/doas.conf

mkdir -p $USER_HOME/home/.cache

pri "Configuring greetd"
ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/USER_HOME/${ESCAPED_USER_HOME}/g" /etc/greetd/config.toml
sed -i "s/USER1/${USER1}/g" /etc/greetd/config.toml
chown greeter:greeter /etc/greetd/config.toml
rc-update add greetd default
rc-update del agetty.tty1 default
rc-update del agetty.tty2 default
rc-update del agetty.tty3 default
rc-update del agetty.tty4 default
rc-update del agetty.tty5 default
rc-update del agetty.tty6 default


sed -i "s/USER1/${USER1}/g" /etc/security/limits.conf

pri "Set password for user $USER1"

if [ "$USER_PASSWORD" != "" ]; then
    pri "${LBLUE}Automaticly filling password..."
    ( echo $USER_PASSWORD; echo $USER_PASSWORD; ) | passwd $USER1
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd $USER1 && break
        n=$((n+1)) 
        sleep 3
    done
fi
chown -R $USER1:$USER1 $USER_HOME

pri "Set password for root"
if [ "$ROOT_PASSWORD" != "" ]; then
    pri "${LBLUE}Automaticly filling password..."
    ( echo $ROOT_PASSWORD; echo $ROOT_PASSWORD; ) | passwd root
else
    n=0
    until [ "$n" -ge 5 ]; do
        passwd root && break
        n=$((n+1)) 
        sleep 3
    done
fi

chsh -s /bin/bash root > /dev/null 2>&1


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

ESCAPED_FAKE_USER_HOME=$(printf '%s\n' "$FAKE_USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/FAKE_USER_HOME/$ESCAPED_FAKE_USER_HOME/g" /etc/fstab

pri "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
#sed -i '1d' /bin/mkinitcpio

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

mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share
