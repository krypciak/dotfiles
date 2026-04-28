#!/bin/sh
set -euo pipefail
MONITORS="$(wlr-randr | grep -E '"*"|Enabled|preferred' | awk '{if ($1 ~ "Enabled") print $2 " "; else if ($1 ~ /[0-9]+x[0-9]+/) print $1 "@"; else print $1 " "}' | tr -d '\n' | tr '@' '\n')"
echo "$MONITORS"
MONITOR_COUNT="$(echo "$MONITORS" | wc -l)"
echo "$MONITOR_COUNT"

if [ "$MONITOR_COUNT" != '1' ]; then
    OUTPUT="$(echo "$MONITORS" | fuzzel -d --log-level none --width 25 --lines 5 | awk '{print $1}')"
else
    OUTPUT="$(echo "$MONITORS" | awk '{print $1}')"
fi

RES_TO_SORT="$(wlr-randr --output "$OUTPUT" | awk '/px/ {print $1 "@" $3 "@" int($3+0.5) }' | tr '\n' ' ')"
prev_res=''
prev_ref=''
prev_refr=''
RES_TO_SEL=""
for inp in $RES_TO_SORT; do
    inp="$(echo $inp | tr '@' ' ')"
    res="$(echo $inp | awk '{print $1}')"
    ref="$(echo $inp | awk '{print $2}')"
    refr="$(echo $inp | awk '{print $3}')"
    RES_TO_SEL="$RES_TO_SEL$res @ $refr \t\t\t\t\t\t\t $ref\n"
done

printf "$RES_TO_SEL"
SEL="$(printf "$RES_TO_SEL" | sort --general-numeric-sort --reverse | fuzzel -d --log-level none --width 17)"
RES="$(echo $SEL | awk '{print $1}')"
REFRESH="$(echo $SEL | awk '{print $4}')"
set -x
wlr-randr --output $OUTPUT --mode "$RES@$REFRESH"
