export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
sh $DIR/kill.sh

RED='\e[91m'
GREEN='\e[32m'
BLUE='\e[34m'
NC='\e[0m'


TEMP_DIR="$DIR/temp"
VIDEOS_DIR="$DIR/videos"

source $DIR/subs.sh

mkdir -p $TEMP_DIR
mkdir -p $VIDEOS_DIR


YT_DLP_ARGS='--sponsorblock-remove all --embed-thumbnail --add-metadata --embed-metadata --embed-chapters --embed-subs --sub-langs all,-live_chat --audio-quality 0 -R infinite --retry-sleep 900 -S quality,ext:mp4,filesize --download-archive downloaded.txt --no-post-overwrites --ignore-errors --newline'

TITLE='%(channel)s - %(title)s.%(ext)s'

function listen_rss() {
    rsstail -z -l -N -n 1 -i 300 -P -u "$1" | while read url; do
        echo -e "${BLUE}Recived RSS URL: ${GREEN}${url}${NC}"

        # If there is less than 2 GiB space left
        while [[ "$(df $VIDEOS_DIR | awk 'NR==2{print $4}')" -le 2097152 ]]; do
            # If no files left to delete, exit
            if [[ "$(ls $VIDEOS_DIR | wc -l)" -eq 0 ]]; then
                echo -e "${RED}Less than 2GiB on $VIDEOS_DIR, exiting${NC}"
                exit 1
            fi
            # Remove the last video
            rm -f "$(LC_CTYPE=C ls -t $VIDEOS_DIR | tail -1)"
        done

        if [[ "$url" == http* ]]; then 
            filename=$(yt-dlp "$url" -o "$TITLE" --print filename)
            old_filename=$(yt-dlp "$url" -o "$TITLE" --restrict-filenames --print filename)
            if [ -f "$VIDEOS_DIR/$filename" ] || [ -f "$VIDEOS_DIR/$old_filename" ]; then 
                echo -e "${BLUE}File exists, skipping${NC}"
            else
                echo -e "${BLUE}Downloading URL: ${GREEN}${url}${BLUE}  Filename: ${GREEN}${filename}${NC}"
                yt-dlp $YT_DLP_ARGS -o "$TITLE" -P "$VIDEOS_DIR" -P "temp:$TEMP_DIR" "$url"
                echo -e "${GREEN}Video: '${BLUE}${filename}${GREEN}' download done${NC}"
            fi
        fi
    done
}

i=0
for feed in ${CHANNEL_FEEDS[@]}; do
    listen_rss "${INSTANCES[$i]}/feed/channel/$feed" &
    sleep 300

    i=$((i+1))
    if [[ ${#INSTANCES[@]} -eq $i ]]; then
        i=0
    fi
done

for feed in ${ODYSEE_FEEDS[@]}; do
    listen_rss "https://odysee.com/$/rss/$feed" &
    sleep 300
done

