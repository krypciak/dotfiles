
#                _           _    _      _        _             _
#        _______| |__       | | _(_) ___| | _____| |_ __ _ _ __| |_
#       |_  / __| '_ \ _____| |/ / |/ __| |/ / __| __/ _` | '__| __|
#        / /\__ \ | | |_____|   <| | (__|   <\__ \ || (_| | |  | |_
#       /___|___/_| |_|     |_|\_\_|\___|_|\_\___/\__\__,_|_|   \__|
#

## INITIALIZATION =============================================================
# By default zcompdump is created in the home directory, so we will create a
# directory for the zsh cache in a separate directory to clean things up a
# little bit.
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Creates the cache directory if doesn't exist, as compinit will fail if it
# doesn't find the directory in which .zcompdump is specified to be located.
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"

# The .zcompdump file is used to improve compinit's initialization time.
ZCOMPDUMP_PATH="$CACHE_DIR/.zcompdump"

## COMPLETIONS ================================================================
# Initializes completion system. Relevant documentation:
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit.
autoload -U compinit
compinit -d "$ZCOMPDUMP_PATH"

# Compiles the .zcompdump to load it faster next time.
# Search for zcompile in https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html.
[[ "$ZCOMPDUMP_PATH.zwc" -nt "$ZCOMPDUMP_PATH" ]] || zcompile "$ZCOMPDUMP_PATH"

# Marks the selected item in the completion menu.
zstyle ':completion:*' menu select

# Makes the completion case-insensitive unless a uppercase is used.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Enables cache. I have not found any real use for it but theoretically it is
# useful to improve the speed of some completions.
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$CACHE_DIR/.zcompcache"

# Attempts to find new commands to complete.
zstyle ':completion:*' rehash true

## KEYBINDINGS ================================================================
# Forces the use of emacs keyboard shortcuts. By default uses the vim ones,
# but they are not very good by default and can be confusing for novice users.
# bindkey -v

# Makes zsh behave the same with words as bash. Recommended to leave it this
# way since by default it simply behaves badly.
autoload -U select-word-style
select-word-style bash

bindkey '^F' forward-char

ls_widget() {
    echo
    lsd
    zle redisplay
}
zle -N ls_widget
bindkey '^[l' ls_widget

## PROMPT =====================================================================
## HISTORY ====================================================================
HISTFILE="$HOME/.zsh_history" # Location of the history file.
HISTSIZE=50000                # Maximum number of commands in the history.
SAVEHIST=10000                # Number of commands to save between sessions.
setopt share_history          # Share history between sessions.


## OTHER ======================================================================
# Disables highlighting of pasted text.
zle_highlight+=(paste:none)

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt autocd

# Makes the "command not found" message more beautiful and informative.
command_not_found_handler() {
    printf "%sERROR:%s command %s not found.\n" \
        "$(printf "\033[1;31m")" "$(printf "\033[0m")" \
        "$(printf "\033[4:3m\033[58:5:1m")$1$(printf "\033[0m")"
    return 127
}

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(atuin init zsh)"
eval "$(atuin gen-completions --shell zsh)"

# Source my stuff

if [ -n "$AT_LOGIN_SOURCED" ]; then
    source ~/.config/at-login.sh
fi
source ~/.config/aliases.sh

lsp() {
    ls -d "$PWD/$@" | head -c -1
}

if [ -n "$WAYLAND_DISPLAY" ]; then
    alias pwdc='pwd | head -c -1 | wl-copy'
    alias pwdv='cd "$(wl-paste)"'
    lspc() {
        lsp "$@" | wl-copy
    }
    
    lsc() {
        ls "$@" | head -c -1 | wl-copy
    }
else
    alias pwdc='pwd | xsel -ib'
    alias pwdv='cd "$(xsel -ob)"'

    lspc() {
        lsp "$@" | xsel -ib
    }

    lsc() {
        ls "$@" | head -c -1 | xsel -ib
    }
fi

source /usr/share/autojump/autojump.zsh

setopt PROMPT_SUBST

autoload -Uz colors && colors

compress_pwd() {
    local -a parts
    local path="${PWD/#$HOME/~}"
    local absolute=0

    [[ "$path" == /* ]] && absolute=1

    parts=("${(@s:/:)path}")

    local out=""
    local keep=1

    [[ $absolute -eq 1 ]] && out="/"

    for ((i=1; i<=$#parts; i++)); do
        [[ -z "${parts[i]}" ]] && continue

        if (( i <= $#parts - keep )); then
            if [[ "${parts[i]}" == "~" ]]; then
                out+="~/"
            else
                out+="${parts[i][1]}/"
            fi
        else
            out+="${parts[i]}"
            (( i < $#parts )) && out+="/"
        fi
    done

    print -r -- "$out"
}

prompt_char() {
    if [[ $EUID -eq 0 ]]; then
        echo -n "%B%F{red}# "
    else
        echo -n "%B%F{red}❯%F{yellow}❯%F{green}❯%f%b "
    fi
}

ssh_info() {
    if [[ -n "$SSH_TTY" ]]; then
        echo -n "%F{brred}%n%f%F{white}@%F{yellow}%m "
    fi
}

PROMPT='$(ssh_info)%F{blue}$(compress_pwd) $(prompt_char)'

# Right prompt: exit code on failure
RPROMPT='%(?..%F{red}✘ %?%f)'
