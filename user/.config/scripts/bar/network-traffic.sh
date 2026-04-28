#!/bin/bash
TIME='4'
MULTI='1'
INTERFACES="$(ip -br a | awk '{print $1}' | grep -vE ^lo | xargs)"

format_KiB() {
    KiB=$((($2 - $1) / 1024 / $TIME))
    if [ $KiB -gt 100 ]; then
        echo "scale = 1; $KiB / 1024" | bc | tr -d '\n'
        printf 'MiB'
    else
        printf "${KiB}KiB"
    fi
}

for MODULE in $INTERFACES; do
    if [ -f /sys/class/net/$MODULE/statistics/tx_bytes ]; then
        rx1=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
        tx1=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)
        sleep $TIME
        rx2=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
        tx2=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)

        printf $MODULE ' '
        printf ''
        format_KiB $rx1 $rx2

        printf ' '
        format_KiB $tx1 $tx2
        printf '  '
    fi
done
#     printf '󰈂'
