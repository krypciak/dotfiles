#!/bin/bash

ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR=$ARTIXD_DIR/..
CONFIGD_DIR=$DOTFILES_DIR/config-files

source "$ARTIXD_DIR/iso-vars.sh"
export PACMAN_ARGUMENTS
export PARU_ARGUMENTS
export YOLO
export USER1

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



pri "Installing base packages"
pacman-key --init
pacman-key --populate artix

pri "Updating keyring"
# Disable package signature verification
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/g' /etc/pacman.conf
sed -i 's/LocalFileSigLevel = Optional/#LocalFileSigLevel = Optional/g' /etc/pacman.conf
# Add lib32 repo
printf '[lib32]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
# Add universe repo
printf '[universe]\nServer = https://universe.artixlinux.org/$arch\nServer = https://mirror1.artixlinux.org/universe/$arch\nServer = https://mirror.pascalpuffke.de/artix-universe/$arch\nServer = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch\nServer = https://mirror1.cl.netactuate.com/artix/universe/$arch\nServer = https://ftp.crifo.org/artix-universe/\n' >> /etc/pacman.conf

PACKAGES_LIST='artix-archlinux-support '
pacman $PACMAN_ARGUMENTS -Sy $PACKAGES_LIST
pacman-key --init
pacman-key --populate

pri "Copying pacman configuration"
cp $CONFIGD_DIR/root/etc/pacman.conf /etc/pacman.conf
cp -r $CONFIGD_DIR/root/etc/pacman.d /etc/
pacman -Sy 

pri "Adding user $USER1"
useradd -s /bin/bash -G tty,ftp,games,network,scanner,users,video,audio,wheel $USER1
mkdir -p $USER_HOME
chown -R $USER1:$USER1 $ARTIXD_DIR

DOTFILES_DIR=$USER_HOME/home/.config/dotfiles
pri "Copying the repo to $DOTFILES_DIR"
mkdir -p $DOTFILES_DIR/..
cp -rf $ARTIXD_DIR/../ $DOTFILES_DIR/

ARTIXD_DIR=$DOTFILES_DIR/artix
CONFIGD_DIR=$DOTFILES_DIR/config-files


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

chown -R $USER1:$USER1 $USER_HOME/

pri "Installing packages"
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


if [ $INSTALL_DOTFILES -eq 1 ]; then
    pri "Installing dotfiles for user $USER1"
    chown $USER1:$USER1 -R $USER_HOME
    doas -u $USER1 sh $DOTFILES_DIR/install-dotfiles.sh

    pri "Installing dotfiles for root"
    sh $DOTFILES_DIR/install-dotfiles-root.sh
fi

fish --command "fish_update_completions"
chown -R $USER1:$USER1 $USER_HOME
doas -u $USER1 fish --command "fish_update_completions"

pri "Cleaning up"
rm -rf $USER_HOME/.cargo
#find /var/cache/pacman/pkg/ -iname "*.part" -delete
paru --noconfirm -Scc > /dev/null 2>&1
rm -r /dotfiles 


pri "Copying configs"
printf "$LBLUE"
cp -rv $CONFIGD_DIR/root_iso/* /
printf "$NC"

ESCAPED_T1=$(printf '%s\n' "run_if_not_running_pgrep({ \"tutanota\" }" | sed -e 's/[\/&]/\\&/g')
sed -i "s/$ESCAPED_T1/--$ESCAPED_T1/g" $USER_HOME/.config/awesome/after_5sec.lua

ESCAPED_T1=$(printf '%s\n' "run_if_not_running_pgrep({ music_player_class }" | sed -e 's/[\/&]/\\&/g')
sed -i "s/$ESCAPED_T1/--$ESCAPED_T1/g" $USER_HOME/.config/awesome/autostart.lua

sed -i "s/USER1/$USER1/g" /etc/doas.conf


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


neofetch

sed -i -E ':a;N;$!ba;s/configure_user\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/configure_language\n//g' /bin/artix-live
sed -i -E ':a;N;$!ba;s/configure_displaymanager\n//g' /bin/artix-live
echo "usermod -aG tty,ftp,games,network,scanner,users,video,audio,wheel,libvirt $USER1" >> /bin/artix-live
echo "chown $USER1:$USER1 -R /home/$USER1/" >> /bin/artix-live

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi

mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share
