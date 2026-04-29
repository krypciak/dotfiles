#!/bin/bash
. ~/.config/at-login.sh
exec start-hyprland > ~/.config/hypr/log.txt 2>&1
