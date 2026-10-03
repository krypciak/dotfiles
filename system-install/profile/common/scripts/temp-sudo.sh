#!/bin/bash
set -e
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1

check_is_root


info "Creating temporary sudo config"

echo 'Defaults!/usr/bin/visudo env_keep += "SUDO_EDITOR EDITOR VISUAL"' >/etc/sudoers
echo 'Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/bin"' >>/etc/sudoers
echo 'root ALL=(ALL:ALL) ALL' >>/etc/sudoers
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >>/etc/sudoers
echo '@includedir /etc/sudoers.d' >>/etc/sudoers
chown root:root /etc/sudoers
chmod 0440 /etc/sudoers
