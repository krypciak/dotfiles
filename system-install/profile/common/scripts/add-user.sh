#!/bin/bash
DIR="$(dirname -- "${BASH_SOURCE[0]}" | xargs realpath)"
DOTDIR="$DIR"/../../../..
. "$DOTDIR/util.sh"

check_is_root
source_vars "$DOTDIR"

info "Adding user <user>$USER1</user>"
if ! id "$USER1" >/dev/null 2>&1; then
    useradd -s /bin/bash -G tty,ftp,games,network,scanner,users,video,audio,wheel "$USER1"
fi
mkdir -p "$USER_HOME"

chown -R "$USER1:$USER1" "$USER_HOME"
