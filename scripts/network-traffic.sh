#!/bin/sh
MODULE='eth0'
TIME='1'
MULTI='1'

function format_KiB() {
    KiB=$((($rx2 - $rx1) / 1024 * $MULTI))
    if [ $KiB -gt 100 ]; then
        echo "scale = 1; $KiB / 1024" | bc | tr -d '\n'; printf 'MiB'
    else
        printf "${KiB}KiB"
    fi
}

if [ "$1" == "download" ]; then
    rx1=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
    sleep $TIME
    rx2=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
    format_KiB
fi
if [ "$1" == "upload" ]; then
    rx1=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)
    sleep $TIME
    rx2=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)
    format_KiB
fi
