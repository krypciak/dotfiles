#!/bin/bash
set -euo pipefail
music_dir="$HOME/Music"
cmus_playlists_dir="$HOME/.config/cmus/playlists"
mkdir -p "$cmus_playlists_dir"

album_dir="$PWD"
album_name="$(basename "$album_dir")";
cmus_playlist="$cmus_playlists_dir/$album_name"

ls -1tr "$album_dir" | awk -v pwd="$PWD" '{print pwd "/" $0}' > "$cmus_playlist"
bat "$cmus_playlist"
