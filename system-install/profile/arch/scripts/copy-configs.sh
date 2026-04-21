DIR="$(printf "$(dirname $0)" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info_garr 'Copying configs'
cp -L -r "$DOTDIR"/system-install/profile/common/root/* /

# arch configs are already copied
