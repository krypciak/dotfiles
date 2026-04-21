#!/bin/bash
[ "$DOTDIR" = '' ] && echo '$DOTDIR variable not set. This script is not ment to be run by the user.' && exit 1
. "$DOTDIR/system-install/vars.conf.sh"

set -a

PORTABLE=1
USER_PASSWORD='123'
ROOT_PASSWORD='123'

LIB32=1
ALL_DRIVERS=1

VARIANT_NAME="Arch ISO"
BOOTLOADER_ID="$VARIANT_NAME"

set +a
