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
        # If there is less than 2 GiB space left
        while [[ "$(df $VIDEOS_DIR --output=avail | tail +2)" -le 2097152 ]]; do
            # If no files left to delete, exit
            if [[ "$(ls $VIDEOS_DIR | wc -l)" -eq 0 ]]; then
                echo -e "${RED}Less than 2GiB on $VIDEOS_DIR, exiting${NC}"
                exit 1
            fi
            # Remove the last video
            last_file="$(LC_CTYPE=C ls -t $VIDEOS_DIR | tail -1)"
            rm -f "$last_file"
        done

        if [[ "$url" == http* ]]; then 
            echo -e "${BLUE}Recived RSS URL: ${GREEN}${url}${NC}"

            filename=$(yt-dlp "$url" -o "$TITLE" $YT_DLP_ARGS --no-warnings --print filename)
            old_filename=$(yt-dlp "$url" -o "$TITLE" $YT_DLP_ARGS --no-warnings --restrict-filenames --print filename)
            if [ -f "$VIDEOS_DIR/$filename" ] || [ -f "$VIDEOS_DIR/$old_filename" ]; then 
                echo -e "${GREEN}Filename: '${BLUE}${filename}${GREEN}' exists, skipping${NC}"
            else
                echo -e "${GREEN}Downloading URL: ${BLUE}${url}${GREEN}  Filename: '${BLUE}${filename}${GREEN}'${NC}"
                yt-dlp $YT_DLP_ARGS -o "$TITLE" -P "$VIDEOS_DIR" -P "temp:$TEMP_DIR" "$url"
                echo -e "${GREEN}Video: '${BLUE}${filename}${GREEN}' download done${NC}"
            fi
        fi
    done
}

i=0
for feed in ${CHANNEL_FEEDS[@]}; do
    listen_rss "${INSTANCES[$i]}/feed/channel/$feed" &

    i=$((i+1))
    if [[ ${#INSTANCES[@]} -eq $i ]]; then
        i=0
    fi
done

for feed in ${ODYSEE_FEEDS[@]}; do
    listen_rss "https://odysee.com/$/rss/$feed" &
done

