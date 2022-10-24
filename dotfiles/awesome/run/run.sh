source ~/.config/at_login.sh

# ~/.xinitrc
export XINITRC="$XDG_CONFIG_HOME/awesome/run/xinitrc"
export XAUTHORITY="$HOME/.config/awesome/run/Xauthority"

exec xinit -- vt1
