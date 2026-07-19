if [[ "${AT_LOGIN_SOURCED-}" != "$USER" ]]; then
    source ~/.config/at-login.sh
fi

source /usr/share/autojump/autojump.bash

source ~/.config/aliases.sh

eval "$(atuin init bash)"
