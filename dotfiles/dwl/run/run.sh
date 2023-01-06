source ~/.config/at_login.sh

export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
mkdir -p $XDG_RUNTIME_DIR
chmod 0700 -R $XDG_RUNTIME_DIR

export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland

export XDG_CURRENT_DESKTOP='dwl'

# simulate a do-while
do=true
while $do ||  [ -f /tmp/restart_dwl ]; do
    do=false
    rm -rf /tmp/restart_dwl > /dev/null 2>&1
    ~/.config/dwl/dwl-dotfiles/dwl -s ~/.config/dwl/somebar/build/somebar > ~/.config/dwl/run/log.txt 2>&1
    [ -f /tmp/restart_dwl ] && echo Restarting dwl...
done

