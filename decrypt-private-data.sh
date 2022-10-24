#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

function pri() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}

RETRY=1
function retry() {
    echo -en "$LBLUE |||$LGREEN Do you wanna retry? $LBLUE(Y/n)? >> $NC"
    read choice
    case "$choice" in 
    y|Y|"" ) RETRY=1;;
    n|N ) RETRY=0;;
    * ) retry "$1" "ignore";;
    esac
    return 0;
}


# Prepare gnupg
GNUPG_DIR=~/.local/share/gnupg
mkdir -p ~/.local/share/gnupg
find $GNUPG_DIR -type f -exec chmod 600 {} \; # Set 600 for files
find $GNUPG_DIR -type d -exec chmod 700 {} \; # Set 700 for directories


PRIV_DIR=$DOTFILES_DIR/dotfiles/private
ENCRYPTED_ARCHIVE=$DOTFILES_DIR/dotfiles/private.tar.gz.gpg

cd $DOTFILES_DIR/dotfiles/
# Check archive
sha512sum --check $ENCRYPTED_ARCHIVE.sha512
if [[ $? == 1 ]]; then
	echo Encrypted archive is corrupted!
	echo $ENCRYPTED_ARCHIVE
	exit 1
fi

# Backup $PRIV_DIR if it exists
if [ -d $PRIV_DIR ]; then
	if [ -d $PRIV_DIR.old ]; then
		rm -rf $PRIV_DIR.old
	fi
	mv $PRIV_DIR $PRIV_DIR.old
fi
# Decrypt
n=0
until [ "$n" -ge 5 ]; do
    if [ ! -z $PRIVATE_DOTFILES_PASSWORD ] && [ $PRIVATE_DOTFILES_PASSWORD != '' ]; then
        pri 'Trying auto-decryption...'
        ( echo $PRIVATE_DOTFILES_PASSWORD; ) | gpg --batch --yes --passphrase-fd 0 --no-symkey-cache --output /tmp/private.tar.gz --decrypt --pinentry-mode=loopback $ENCRYPTED_ARCHIVE && break
        pri "${RED}Auto decryption failed with password: '$PRIVATE_DOTFILES_PASSWORD'"
        PRIVATE_DOTFILES_PASSWORD=''
    fi
    gpg --output /tmp/private.tar.gz --decrypt --pinentry-mode=loopback $ENCRYPTED_ARCHIVE && break
    n=$((n+1)) 
    retry
    if [ $RETRY -eq 0 ]; then exit 0; fi
done

cd $DOTFILES_DIR/dotfiles/
tar -xf /tmp/private.tar.gz 
rm -f /tmp/private.tar.gz
sh $PRIV_DIR/install.sh
