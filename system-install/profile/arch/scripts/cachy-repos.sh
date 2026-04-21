#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root

info_garr "Installing cachy repos"

curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
# shopt -s expand_aliases
# alias pacman='pacman --noconfirm'
# perl -0777 -i -pe 's/(\s*local is_repo_added)/ "\${mirror_url}\/cachyos-rate-mirrors-23-1-any.pkg.tar.zst"\ncachyos-rate-mirrors\1/g' cachyos-repo.sh
# . cachyos-repo.sh

file="cachyos-repo.sh"
mirror_url=$(grep "^[[:space:]]*local mirror_url=" "$file" | sed 's/.*="\([^"]*\)".*/\1/')
grep "^[[:space:]]*pacman-key" "$file" | grep -v "delete" | while read -r cmd; do
    eval "$cmd"
done
packages=$(sed -n '/pacman -U/,/^[A-Za-z]/p' "$file" | \
    grep -oP '/[^"]+\.pkg\.tar\.zst' | \
    sed "s|^|${mirror_url}|" | \
    tr '\n' ' ')

pacman $PACMAN_ARGUMENTS -U $packages

cd ..
rm -r cachyos-repo.tar.xz cachyos-repo

info "Done"
