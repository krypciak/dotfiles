DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info_garr 'Copying configs'
rm -rf /usr/share/X11/xkb
cp -L -r "$DOTDIR"/system-install/profile/common/root/* /

# (most) arch configs are already copied
# just make sure the correct pacman config is there
"$DIR"/copy-pacman-config.sh

if [ "$TYPE" = 'iso' ]; then
    cp -L -r "$DOTDIR"/system-install/profile/iso/root/* /
fi
