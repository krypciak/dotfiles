if [[ "${AT_LOGIN_SOURCED-}" != "$USER" ]]; then
    source ~/.config/at-login.sh
fi


# Start fish, except when bash was executed inside of fish
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]; then
    exec fish
fi

source /usr/share/autojump/autojump.bash

source ~/.config/aliases.sh

eval "$(atuin init bash)"
