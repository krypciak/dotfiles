#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USER_HOME="/home/$USER1"

DIRS=(
	".mozilla/icecat/rgvol6f2.default/extension-settings.json"      ""
    ".mozilla/icecat/rgvol6f2.default/search.json.mozlz4"           ""
    ".mozilla/icecat/rgvol6f2.default/extension-settings.json"      ""
    ".mozilla/icecat/rgvol6f2.default/extensions.json"              ""
    ".mozilla/icecat/rgvol6f2.default/sessionCheckpoints.json"      ""
)

echo "Syncing..."
for (( i=0; i<${#DIRS[@]}; i+=2 )); do
    T1=${DIRS[i]}
    T2=${DIRS[$(expr $i + 1)]}
    
    FROM="$USER_HOME/$T2/$T1"
    DEST="$DOTFILES_DIR/dotfiles/$T1"

    mkdir -p "$(dirname $DEST | head --lines 1)"
	cp -rvf "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done


