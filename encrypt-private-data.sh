#!/bin/sh

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Prepare gnupg
GNUPG_DIR=~/.local/share/gnupg
mkdir -p ~/.local/share/gnupg
find $GNUPG_DIR -type f -exec chmod 600 {} \; # Set 600 for files
find $GNUPG_DIR -type d -exec chmod 700 {} \; # Set 700 for directories


ENCRYPTED_ARCHIVE_NAME=private.tar.gz.gpg
ENCRYPTED_ARCHIVE=$DOTFILES_DIR/dotfiles/$ENCRYPTED_ARCHIVE_NAME

if [ -f $DOTFILES_DIR/dotfiles/private/sync.sh ]; then
    sh $DOTFILES_DIR/dotfiles/private/sync.sh
fi

cd $DOTFILES_DIR/dotfiles
tar -cz private | gpg --batch --yes --symmetric --output $ENCRYPTED_ARCHIVE
rm -r $ENCRYPTED_ARCHIVE.sha512
sha512sum private.tar.gz.gpg > $ENCRYPTED_ARCHIVE.sha512


