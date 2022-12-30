export DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
sh $DIR/kill.sh

TEMP_DIR="$DIR/temp"
VIDEOS_DIR="$DIR/videos"


source $DIR/subs.sh

mkdir -p $TEMP_DIR
mkdir -p $VIDEOS_DIR


YT_DLP_ARGS="--sponsorblock-remove all --embed-thumbnail --add-metadata --embed-metadata --embed-chapters --all-subs --embed-subs --audio-quality 0 -R infinite --retry-sleep 900 -S quality,ext:mp4,filesize --download-archive downloaded.txt --no-post-overwrites --ignore-errors --newline"


function listen_rss() {
    rsstail -z -l -N -n 1 -i 300 -P -u "$1" | while read url; do

        # If there is less than 2 GiB space left
        while [[ "$(df $VIDEOS_DIR | awk 'NR==2{print $4}')" -le 2097152 ]]; do
            # If no files left to delete, exit
            if [[ "$(ls $VIDEOS_DIR | wc -l)" -eq 0 ]]; then
                echo -e "\e[32mLess than 2GiB on $VIDEOS_DIR, exiting\e[0m"
                exit 1
            fi
            # Remove the last video
            rm -f "$(LC_CTYPE=C ls -t $VIDEOS_DIR | tail -1)"
        done

        if [[ "$url" == http* ]]; then 
            echo -e "\e[32m${url}\e[0m"
            yt-dlp $YT_DLP_ARGS -o "%(channel)s - %(title)s.%(ext)s" -P "$VIDEOS_DIR" -P "temp:$TEMP_DIR" "$url"
            echo -e "\e[32mDownload Done\e[0m"
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

