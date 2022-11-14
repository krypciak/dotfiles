export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
    
# ~/.gtkrc-2.0
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# ~/.icons
export XCURSOR_PATH=/usr/share/icons:${XDG_DATA_HOME}/icons

# ~/.wine
export WINEPREFIX="$XDG_DATA_HOME/wine"


export $(dbus-launch)
export QT_QPA_PLATFORMTHEME=qt5ct

export PATH="/home/$USER1/.local/bin:$PATH"

export EDITOR='nvim'
export CM_LAUNCHER=rofi

export USER1=$USER



