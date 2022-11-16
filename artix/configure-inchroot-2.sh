#!/bin/bash

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

if [ "$ISO" == "yes" ]; then
    sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
fi

pri "Adding user $USER1"
if ! id "$USER1" &>/dev/null; then
    useradd -s /bin/bash -G tty,ftp,games,network,scanner,users,video,audio,wheel $USER1
    mkdir -p $USER_HOME
    chown -R $USER1:$USER_GROUP $USER_HOME/
    chown -R $USER1:$USER_GROUP $ARTIXD_DIR
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
    chown -R $USER1:$USER_GROUP /tmp/paru
    chmod +wrx /tmp/paru
    cd /tmp/paru
    doas -u $USER1 makepkg -si --noconfirm --needed
fi
cp $CONFIGD_DIR/root/etc/paru.conf /etc/paru.conf

pri "Disabling mkinitcpio"
mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook 


confirm "Install packages?"
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

