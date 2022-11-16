#!/bin/bash

chown -R $USER1:$USER_GROUP $USER_HOME/

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
chown -R $USER1:$USER_GROUP $USER_HOME
doas -u $USER1 fish --command "fish_update_completions"

chmod -rw /etc/doas.conf
