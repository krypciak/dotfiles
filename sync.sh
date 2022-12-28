#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USER_HOME="/home/$USER1"

DIRS=(
    ".mozilla/icecat/rgvol6f2.default/prefs.js" ""
    ".mozilla/icecat/rgvol6f2.default/search.json.mozlz4" ""
    ".mozilla/icecat/rgvol6f2.default/storage.sqlite" ""
    ".mozilla/icecat/rgvol6f2.default/cookies.sqlite" ""
    ".mozilla/icecat/rgvol6f2.default/extension-settings.json" ""
    ".mozilla/icecat/rgvol6f2.default/extensions.json" ""
    ".mozilla/icecat/rgvol6f2.default/sessionCheckpoints.json" ""

    ".librewolf/profile0/prefs.js" ""
    ".librewolf/profile0/search.json.mozlz4" ""
    ".librewolf/profile0/storage.sqlite" ""
    ".librewolf/profile0/cookies.sqlite" ""
    ".librewolf/profile0/extension-settings.json" ""
    ".librewolf/profile0/extensions.json" ""
    ".librewolf/profile0/sessionCheckpoints.json" ""

    "ice/firefox/invidious/prefs.js" ".local/share"
    "ice/firefox/invidious/search.json.mozlz4" ".local/share"
    "ice/firefox/invidious/storage" ".local/share"
    "ice/firefox/invidious/storage.sqlite" ".local/share"
    "ice/firefox/invidious/cookies.sqlite" ".local/share"
    "ice/firefox/invidious/extension-settings.json" ".local/share"
    "ice/firefox/invidious/extensions.json" ".local/share"
    "ice/firefox/invidious/sessionCheckpoints.json" ".local/share"
    "ice/firefox/invidious/user.js" ".local/share"
    "ice/firefox/invidious/chrome" ".local/share"
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


