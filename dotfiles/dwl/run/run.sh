source ~/.config/at_login.sh

export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
mkdir -p $XDG_RUNTIME_DIR
dwl -s somebar
