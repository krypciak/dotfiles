#!/bin/bash
set -a

QT_QPA_PLATFORMTHEME=qt6ct

LANG='en_US.UTF-8'

EDITOR='nvim'
CM_LAUNCHER=rofi

GIT_DISCOVERY_ACROSS_FILESYSTEM=1

if [ "$(whoami)" = 'root' ]; then
    USER_HOME="/root"
    AT_LOGIN_SOURCED="$USER"
else
    USER_HOME="/home/$USER"
    AT_LOGIN_SOURCED="$USER"
fi

PNPM_HOME="$USER_HOME/.local/share/pnpm"
PATH="$USER_HOME/.local/bin:$USER_HOME/.cargo/bin:$PATH:$USER_HOME/.config/scripts:$PNPM_HOME:$USER_HOME/Programming/android/sdk/tools:$USER_HOME/.dotnet/tools"

XDG_DATA_HOME="$USER_HOME/.local/share"
XDG_STATE_HOME="$USER_HOME/.local/state"
XDG_CONFIG_HOME="$USER_HOME/.config"
XDG_CACHE_HOME="$USER_HOME/.cache"

# ~/.gtkrc-2.0
GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
# ~/.icons
XCURSOR_PATH=/usr/share/icons:"$XDG_DATA_HOME"/icons
# ~/.wine
WINEPREFIX="$XDG_DATA_HOME"/wine
# ~/.bash_history
mkdir -p "$XDG_STATE_HOME"/bash
HISTFILE="$XDG_STATE_HOME"/bash/history
# ~/.grupg
GNUPGHOME="$XDG_DATA_HOME"/gnupg
# ~/.cargo
CARGO_HOME="$XDG_DATA_HOME"/cargo
# ~/go
GOPATH="$XDG_DATA_HOME"/go
# ~/.gradle
GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
# ~/.ICEauthority
ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
# ~/.node_repl_history
NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

LIBSEAT_BACKEND=logind

ANDROID_HOME="$USER_HOME/Programming/android/sdk"
ANDROID_SDK_ROOT="$USER_HOME/Programming/android/sdk"
ANDROID_AVD_HOME="$USER_HOME/.android/avd"

RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/flags"

set +a
