source ~/.config/at-login.sh

# Start fish, except when bash was executed inside of fish
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]; then
    exec fish
fi

source /usr/share/autojump/autojump.bash

source ~/.config/aliases.sh

eval "$(atuin init bash)"

_doas_func() { if [ "$1" = "su" ] || [ "$1" = "bash" ] || [ "$1" = "fish" ]; then echo no; else doas "$@"; fi; }
alias doas='_doas_func'
