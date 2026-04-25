#!/bin/bash
yt-dlp -x --audio-quality 0 -f bestaudio --embed-thumbnail --embed-subs --audio-format mp3 --add-metadata -o '%(artist)s - %(track)s.%(ext)s' "$1"
