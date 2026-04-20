#!/bin/bash
DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root

info_garr "Installing cachy repos"

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
shopt -s expand_aliases
alias pacman='pacman --noconfirm'
# perl -0777 -i -pe 's/(\s*local is_repo_added)/ "\${mirror_url}\/cachyos-rate-mirrors-23-1-any.pkg.tar.zst"\ncachyos-rate-mirrors\1/g' cachyos-repo.sh
. cachyos-repo.sh

cd ..
rm -r cachyos-repo.tar.xz cachyos-repo

info "Done"
