#!/bin/sh

_install_baltie() {
    set +e
    ping -c 1 gnu.org > /dev/null 2>&1 || return

    [ ! -f '/tmp/baltie.zip' ] && wget https://sgpsys.com/download/b3/b3_u_plk.zip -O /tmp/baltie.zip
    [ ! -f '/tmp/setup.exe' ] && unzip /tmp/baltie.zip -d /tmp/
    
    innoextract --silent --info --language ENG --extract --output-dir "/tmp/baltie-extracted" /tmp/setup.exe
    
    BASE_DIR="$USER_HOME/.local/share/wine/drive_c/Program Files (x86)/SGP Systems"
    INSTALL_DIR="$BASE_DIR/SGP Baltie 3"
    
    mkdir -p "$BASE_DIR"
    rm -rf "$INSTALL_DIR"
    mv /tmp/baltie-extracted/app "$INSTALL_DIR"
    
    mkdir -p "$USER_HOME"/.local/share/applications
    cp "$DB"/profile/common/configs/Baltie3.desktop "$USER_HOME"/.local/share/applications/
    chown "$USER1:$USER_GROUP" -R "$USER_HOME"/.local/share/applications
    chmod +x "$USER_HOME"/.local/share/applications/Baltie3.desktop
    chown "$USER1:$USER_GROUP" -R "$USER_HOME"/.local/share/wine

    # Init wine prefix
    doas -u "$USER1" env WINEPREFIX="$USER_HOME/.local/share/wine" DISPLAY='' WAYLAND_DISPLAY='' timeout 5s /usr/bin/wine "C:\\\\Program Files (x86)\\\\SGP Systems\\\\SGP Baltie 3\\\\baltie.exe" > /dev/null 2>&1
    pkill wine
    pkill '.exe'

    pkill -9 wine
    pkill -9 '.exe'
    set -e
}

artix_baltie_install() {
    echo 'innoextract'
}

arch_baltie_install() {
    echo 'innoextract'
}


artix_baltie_configure() {
    _install_baltie
}

arch_baltie_configure() {
    _install_baltie
}

