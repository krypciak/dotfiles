#!/bin/bash
set -euo pipefail
ls -tr -- *.mp3 | tr '\n' '\0' | while IFS= read -r -d '' f; do
    title="$(taffy "$f" | grep "title" | tail -c +10)"
    new_title="$(echo "$title" | vipe)"
    echo 'old: ' $title
    echo 'new: ' $new_title
    taffy "$f" --title "$new_title"
    echo
done
