#!/bin/bash
set -e

_util() {
    set -a
    RED="$(printf '\033[31m')"
    ORANGE="$(printf '\033[38;5;208m')"
    BLUE="$(printf '\033[0;34m')"
    LIGHT_BLUE="$(printf '\033[1;34m')"
    LIGHT_GREEN="$(printf '\033[1;32m')"
    BOLD="$(printf '\033[1m')"
    ITALIC="$(printf '\033[3m')"
    UNDERLINE="$(printf '\033[4m')"
    NC="$(printf '\033[0m')"

    _process_msg() {
        printf '%s' "$*" |
            sed -e "s|<path>|$ORANGE|g" \
                -e "s|</path>|$NC|g" \
                -e "s|<user>|$ORANGE|g" \
                -e "s|</user>|$NC|g"
    }

    info() { printf "${BLUE}::${NC} ${BOLD}$(_process_msg "$(_process_msg "$*")")${NC}\n"; }

    info_garr() { printf "${LIGHT_GREEN}${BOLD}==>${NC} ${BOLD}$(_process_msg "$*")${NC}\n"; }

    info_barr() { printf "  ${BLUE}${BOLD}->${NC} ${BOLD}$(_process_msg "$*")${NC}\n"; }

    warn() { printf "${ORANGE}::${NC} ${BOLD}$(_process_msg "$*")${NC}\n"; }

    err() { printf "${RED}::${NC} ${BOLD}$(_process_msg "$*")${NC}\n"; }

    confirm() {
        set +a
        shell=0
        y='y'
        n='n'
        ignore=0
        barr=0

        args="$1"
        for _arg in $args; do
            [ "$_arg" = 'Y' ] && y='Y'
            [ "$_arg" = 'N' ] && n='N'
            [ "$_arg" = 'shell' ] && shell=1
            [ "$_arg" = 'ignore' ] && ignore=1
            [ "$_arg" = 'barr' ] && barr=1
        done
        shift

        while true; do
            if [ "$barr" -eq 1 ]; then
                printf "${BLUE} ->${NC}"
            else
                printf "${BLUE}::${NC}"
            fi
            printf " ${BOLD}$(_process_msg "$1")${NC} ${LIGHT_BLUE}${BOLD}(${y}/${n}"
            [ "$shell" -eq 1 ] && printf '/shell'
            printf ") >> ${NC}"

            if [ "$YOLO" -eq 1 ] && [ "$ignore" -eq 0 ]; then
                printf 'y\n'
                eval "$2"
                break
            else
                read -r choice
                case "$choice" in
                y | Y)
                    eval "$2"
                    break
                    ;;
                n | N)
                    eval "$3"
                    break
                    ;;
                shell)
                    if [ "$shell" -eq 1 ]; then
                        export PS1="${ORANGE}${BOLD}Confirm shell${NC} >> "
                        set +e
                        /bin/sh
                        set -e
                        unset PS1
                    else continue; fi
                    ;;
                '')
                    if [ "$y" = 'Y' ]; then
                        eval "$2"
                        break
                    fi
                    if [ "$n" = 'N' ]; then
                        eval "$3"
                        break
                    fi
                    continue
                    ;;
                *) continue ;;
                esac
            fi
        done
        set -a
    }

    chown_user() { for path in "$@"; do chown -R $USER1:$USER1 "$path"; done; }

    chown_root() { for path in "$@"; do chown -R root:root "$path"; done; }

    slient() { "$@" >/dev/null; }

    slient_err() { "$@" >/dev/null 2>&1; }

    ignore_err() { "$@" || :; }

    check_is_root() {
        if [ "$(whoami)" != 'root' ]; then
            err 'This script needs to be run as root.'
            exit 1
        fi
    }

    check_isnt_root() {
        if [ "$(whoami)" = 'root' ]; then
            err 'This script cant be run as root.'
            exit 1
        fi
    }

    handle_args() {
        SYNTAX="-h|--help=_help,$1"
        shift

        short_names_toparse=''
        long_names_toparse=''
        tocheck=''
        required_set=''
        IFS=','
        index=0
        for arg in $SYNTAX; do
            shifts=1
            required=0
            arg_required=0
            short_name=''
            long_name=''
            names="$(echo "$arg" | awk -F'=' '{print $1}')"
            if [ "$(echo "$names" | tail -c -2)" = 'R' ]; then
                required=1
                names="$(echo "$names" | head -c -2)"
            fi
            if [ "$(echo "$names" | tail -c -2)" = ':' ]; then
                arg_required=1
                names="$(echo "$names" | head -c -2)"
            fi

            if [ "$(echo "$names" | head -c 2)" = '--' ]; then
                if [ "$(echo "$names" | grep "|")" = '' ]; then
                    long_name="$names"
                else
                    long_name="$(echo "$names" | awk -F'|' '{print $1}')"
                    short_name="$(echo "$names" | awk -F'|' '{print $2}')"
                fi
            fi
            if [ "$(echo "$names" | head -c 1)" = '-' ]; then
                if [ "$(echo "$names" | grep "|")" = '' ]; then
                    short_name="$names"
                else
                    short_name="$(echo "$names" | awk -F'|' '{print $1}')"
                    long_name="$(echo "$names" | awk -F'|' '{print $2}')"
                fi
            fi

            if [ "$short_name" != '' ]; then
                short_names_toparse="$short_names_toparse,$(
                    printf -- "$short_name" | tail -c +2
                    [ "$arg_required" = '1' ] && printf ':' || true
                )"
                tocheck="$tocheck,$(
                    printf -- "$short_name"
                    [ "$arg_required" = '1' ] && printf ':' || true
                    printf 'R'
                    printf "@$index"
                    printf '='
                    echo "$arg" | awk '{print substr($0, index($0, "=")+1)}'
                )"
            fi
            if [ "$long_name" != '' ]; then
                long_names_toparse="$long_names_toparse,$(
                    printf -- "$long_name" | tail -c +3
                    [ "$arg_required" = '1' ] && printf ':' || true
                )"
                tocheck="$tocheck,$(
                    printf -- "$long_name"
                    [ "$arg_required" = '1' ] && printf ':' || true
                    printf 'R'
                    printf "@$index"
                    printf '='
                    echo "$arg" | awk '{print substr($0, index($0, "=")+1)}'
                )"
            fi
            [ "$required" = '1' ] && required_set="$index|$required_set"
            index=$((index + 1))
        done
        short_names_toparse="$(echo "$short_names_toparse" | tail -c +2)"
        long_names_toparse="$(echo "$long_names_toparse" | tail -c +2)"
        tocheck="$(echo "$tocheck" | tail -c +2)"

        if ! opts=$(getopt --alternative --name install --options "$short_names_toparse" --longoptions "$long_names_toparse" -- "$@"); then
            _help
            exit 1
        fi

        eval set -- "$opts"
        while true; do
            [ "$1" = '--' ] && break
            for arg in $tocheck; do
                required=0
                arg_required=0
                name="$(echo "$arg" | awk -F'=' '{print $1}')"
                index="${name##*@}"
                name="$(echo "$name" | head -c -"$(echo ${#index}+2 | bc)")"
                if [ "$(echo "$name" | tail -c -2)" = 'R' ]; then
                    required=1
                    name="$(echo "$name" | head -c -2)"
                fi
                if [ "$(echo "$name" | tail -c -2)" = ':' ]; then
                    arg_required=1
                    name="$(echo "$name" | head -c -2)"
                fi

                if [ "$1" = "$name" ]; then
                    eval "$(echo "$arg" | awk '{print substr($0, index($0, "=")+1)}')"
                    shift
                    [ "$arg_required" = '1' ] && shift
                    if [ "$required" = '1' ]; then
                        required_set="$(printf "$required_set" | tr '|' '\n' | grep -v "$index" | head -c -1 | tr '\n' '|')"
                    fi
                    continue 2
                fi
            done
            shift
        done
        if [ "$required_set" != '' ]; then
            IFS="|"
            for missing_index in $required_set; do
                IFS=","
                for arg in $tocheck; do
                    required=0
                    name="$(echo "$arg" | awk -F'=' '{print $1}')"
                    index="${name##*@}"
                    name="$(echo "$name" | head -c -"$(echo ${#index}+2 | bc)")"
                    if [ "$(echo "$name" | head -c 2)" = '--' ]; then
                        if [ "$(echo "$name" | tail -c -2)" = 'R' ]; then
                            required=1
                            name="$(echo "$name" | head -c -2)"
                        fi
                        if [ "$(echo "$name" | tail -c -2)" = ':' ]; then name="$(echo "$name" | head -c -2)"; fi

                        if [ "$missing_index" = "$index" ]; then
                            err "Missing argument: $name"
                            required_set="$(printf "$required_set" | tr '|' '\n' | grep -v "$index" | head -c -1 | tr '\n' '|')"
                        fi
                    fi
                done
                IFS="|"
            done
            IFS="|"
            for missing_index in $required_set; do
                IFS=","
                for arg in $tocheck; do
                    required=0
                    name="$(echo "$arg" | awk -F'=' '{print $1}')"
                    index="${name##*@}"
                    name="$(echo "$name" | head -c -"$(echo ${#index}+2 | bc)")"
                    if [ "$(echo "$name" | head -c 1)" = '-' ]; then
                        if [ "$(echo "$name" | tail -c -2)" = 'R' ]; then
                            required=1
                            name="$(echo "$name" | head -c -2)"
                        fi
                        if [ "$(echo "$name" | tail -c -2)" = ':' ]; then name="$(echo "$name" | head -c -2)"; fi

                        if [ "$missing_index" = "$index" ]; then
                            err "Missing argument: $name"
                        fi
                    fi
                done
                IFS="|"
            done
            _help
            exit 1
        fi

        unset IFS
    }

    source_vars() {
        if [ "$VARS_SOURCED" != "1" ]; then
            if [ "$TYPE" = 'iso' ]; then
                . "$1/system-install/vars.conf.iso.sh"
            else
                . "$1/system-install/vars.conf.sh"
            fi
            VARS_SOURCED=1
        fi
    }

    OS_VARIANT="$(grep '^ID=' /etc/os-release | cut -d= -f2)"

    USER_HOME="/home/$USER"

    [ -z "$YOLO" ] && YOLO=0

    mkdir -p "$USER_HOME"

    GIT_DISCOVERY_ACROSS_FILESYSTEM=1

    UTIL_SOURCED=1
}

if [ "$UTIL_SOURCED" != '1' ]; then
    _util
fi
