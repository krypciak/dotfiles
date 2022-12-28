#~/bin/sh

USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SYMLINK_FROM_TO=( 
    "at_login.sh"           ".config"
    "awesome"               ".config"
    "nvim"                  ".config"
    "alacritty"             ".config"
    "ttyper"                ".config"
    "redshift"              ".config"
    "copyq"                 ".config"
    "fish"                  ".config"
    "xsessions"             ".config"
    "cmus/autosave"         ".config"
    "cmus/red_theme.theme"  ".config"
    "cmus/notify.sh"        ".config"
    "topgrade.toml"         ".config"
    "neofetch"              ".config"
    "chromium/Default/Extensions"                   ".config"
    "chromium/Default/Sync Extension Settings"      ".config"
    "chromium/Default/Managed Extension Settings"   ".config"
    "chromium/Default/Local Extension Settings"     ".config"
    "BetterDiscord/plugins" ".config"
    ".bashrc"               ""
    ".xinitrc"               ""
    "dwl"                   ".config"
    "gammastep"             ".config"
    "fuzzel"                ".config"
    "swaylock"              ".config"
    "Ferdium/config"        ".config"

    ".mozilla/icecat/profiles.ini" ""
    ".mozilla/icecat/rgvol6f2.default/extension-preferences.json" ""
    ".mozilla/icecat/rgvol6f2.default/extensions" ""

    ".librewolf/native-messaging-hosts" ""
    ".librewolf/profiles.ini" ""
    ".librewolf/profile0/extension-preferences.json" ""
    ".librewolf/profile0/extensions" ""

    "wallpapers"            ".config"
    "rofi"                  ".config"
    "ice/icons"             ".local/share"
    "ice/firefox/invidious/extension-preferences.json" "%.local/share"
    "ice/firefox/invidious/extensions" "%.local/share"

    "tridactyl"             ".config"
)


# If path starts with %, will not override
COPY_FROM_TO=(
    "chromium/Default/Preferences"  ".config"
    "chromium/Default/Cookies"      "%.config"
    "chromium/Local State"          ".config"
    "chromium-flags.conf"           ".config"
    "tutanota-desktop/conf.json"    ".config"
    "discord/settings.json"         ".config"
    "FreeTube/settings.db"          ".config"
    "PrismLauncher/multimc.cfg"           ".local/share"
    "gtk-2.0"               ".config"
    "gtk-3.0"               ".config"
    "gtk-4.0"               ".config"
    "qt5ct"                 ".config"
    "kdeglobals"            ".config"
    "keepassxc"             ".config"
    "applications/tutanota-desktop.desktop" ".local/share"
    "applications/arch-update.desktop"  ".local/share"
    "applications/invidious.desktop"  ".local/share"


    ".mozilla/icecat/rgvol6f2.default/prefs.js" "%"
    ".mozilla/icecat/rgvol6f2.default/search.json.mozlz4" "%"
    ".mozilla/icecat/rgvol6f2.default/storage" "%"
    ".mozilla/icecat/rgvol6f2.default/storage.sqlite" "%"
    ".mozilla/icecat/rgvol6f2.default/cookies.sqlite" "%"
    ".mozilla/icecat/rgvol6f2.default/extension-settings.json" "%"
    ".mozilla/icecat/rgvol6f2.default/extensions.json" "%"
    ".mozilla/icecat/rgvol6f2.default/sessionCheckpoints.json" "%"

    ".librewolf/profile0/prefs.js" "%"
    ".librewolf/profile0/search.json.mozlz4" "%"
    ".librewolf/profile0/storage" "%"
    ".librewolf/profile0/storage.sqlite" "%"
    ".librewolf/profile0/cookies.sqlite" "%"
    ".librewolf/profile0/extension-settings.json" "%"
    ".librewolf/profile0/extensions.json" "%"
    ".librewolf/profile0/sessionCheckpoints.json" "%"

    "ice/firefox/invidious/prefs.js" "%.local/share"
    "ice/firefox/invidious/search.json.mozlz4" "%.local/share"
    "ice/firefox/invidious/storage" "%.local/share"
    "ice/firefox/invidious/storage.sqlite" "%.local/share"
    "ice/firefox/invidious/cookies.sqlite" "%.local/share"
    "ice/firefox/invidious/extension-settings.json" "%.local/share"
    "ice/firefox/invidious/extensions.json" "%.local/share"
    "ice/firefox/invidious/sessionCheckpoints.json" "%.local/share"
    "ice/firefox/invidious/user.js" "%.local/share"
    "ice/firefox/invidious/chrome" "%.local/share"
)

LINK_HOME_DIRS=(
    ".config"
    ".local"
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Programming"
    "VM"
    "Games"
    "Temp"
    "Music"
    ".mozilla"
)

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
NC='\033[0m' 

function confirm() {
	echo -en "$LBLUE |||$GREEN Do you want to override ${LGREEN}$1 $2 $3 $LBLUE(Y/n)? >> $NC"
	if [ ! -z $YOLO ] && [ $YOLO -eq 1 ]; then
		echo "y"
		rm -r "$1"
		return
	fi
	read choice
	case "$choice" in 
	y|Y|"" ) rm -r "$1";;
	n|N ) return;;
	* ) confirm $1 $2 $3; return;;
	esac
}

mkdir -p $USER_HOME
mkdir -p $FAKE_USER_HOME

for dir in "${LINK_HOME_DIRS[@]}"; do
	DEST="$USER_HOME/$dir"
	if [ -h "$DEST" ]; then unlink "$DEST"; fi
	if [ -e "$DEST" ]; then confirm $DEST; fi
	mkdir -p $FAKE_USER_HOME/$dir
	ln -sfT $FAKE_USER_HOME/$dir $DEST
done


for (( i=0; i<${#SYMLINK_FROM_TO[@]}; i+=2 )); do
    FROM=${SYMLINK_FROM_TO[i]}
    DEST1=${SYMLINK_FROM_TO[$(expr $i + 1)]}

    OVERRIDE=1
    if [[ $DEST1 = %* ]]; then OVERRIDE=0; DEST1="${DEST1:1}"; fi
    
    DEST="$USER_HOME/$DEST1/$FROM"

    FROM="$DOTFILES_DIR/dotfiles/$FROM"

	if [ $OVERRIDE -eq 1 ] || [ ! -e "$DEST" ]; then
        if [ -h "$DEST" ]; then unlink "$DEST"; fi
        if [ -e "$DEST" ]; then confirm "$DEST"; fi

        mkdir -p "$(dirname $DEST | head --lines 1)"
        ln -sfT "$FROM" "$DEST"
	    chown -R $USER1:$USER1 "$DEST"
    fi
done

for (( i=0; i<${#COPY_FROM_TO[@]}; i+=2 )); do
    FROM=${COPY_FROM_TO[i]}
    DEST1=${COPY_FROM_TO[$(expr $i + 1)]}

    OVERRIDE=1
    if [[ $DEST1 = %* ]]; then OVERRIDE=0; DEST1="${DEST1:1}"; fi

    DEST="$USER_HOME/$DEST1/$FROM"

    FROM="$DOTFILES_DIR/dotfiles/$FROM"

    #printf "$FROM -> $DEST\n$OVERRIDE\n"
	if [ $OVERRIDE -eq 1 ] || [ ! -e "$DEST" ]; then
        if [ -h "$DEST" ]; then unlink "$DEST"; fi
        if [ -e "$DEST" ]; then confirm "$DEST"; fi

        mkdir -p "$(dirname $DEST | head --lines 1)"
		cp -rf "$FROM" "$DEST"
	    chown -R $USER1:$USER1 "$DEST"
    fi
done


ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/PrismLauncher/multimc.cfg
ESCAPED_HOSTNAME=$(printf '%s\n' "$(hostname)" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOSTNAME/$ESCAPED_HOSTNAME/g" $USER_HOME/.local/share/PrismLauncher/multimc.cfg

sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/applications/invidious.desktop
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/applications/arch-update.desktop



chmod +x $USER_HOME/.config/awesome/run/run.sh
chmod +x $USER_HOME/.config/at_login.sh


# Update nvim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1
