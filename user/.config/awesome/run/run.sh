source ~/.config/at-login.sh

dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets

export XINITRC=$HOME/.config/awesome/run/xinitrc

export GTK_IM_MODULE='fcitx'
export QT_IM_MODULE='fcitx'
export SDL_IM_MODULE='fcitx'
export XMODIFIERS='@im=fcitx'

# exec dbus-launch --exit-with-session startx
startx
