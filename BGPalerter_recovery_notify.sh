#!/bin/bash

#
LOG_FILE="/home/BGPalerter/logs/reports.log"

TELEGRAM_BOT_KEY="bot<_BOT_ID_>"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_KEY/sendMessage"
TELEGRAM_CHAT_ID="_CHAT_ID_"
#

NOW=$(date +%s)

LAST_LOG=$(($NOW - $(date +%s -r $LOG_FILE)))

if [ "$LAST_LOG" -le "65" ]; then

    PATERN=$(cat $LOG_FILE | grep "has been withdrawn")

    while read -r line; do
        LOG_TIME=$(echo $line | cut -d' ' -f1)
        LOG_TIME=$(date -d$LOG_TIME +'%s')
        LOG_TIME=$(($NOW - $LOG_TIME))
        if [ "$LOG_TIME" -le "90" ]; then
            PREFIX_ALERT=$(echo $line | cut -d' ' -f5)
            PREFIX_MASK=$(echo "bgp_"$PREFIX_ALERT | sed -r 's/\//_/g')
            echo $PREFIX_ALERT > /tmp/$PREFIX_MASK
        fi
    done <<< "$PATERN"
fi

for file in /tmp/bgp_* ; do
    if [ -f $file ]; then
        PREFIX=$(cat $file)
        VISABILITY=$(/usr/local/bin/ripestat -w routing_status $PREFIX | grep --text -i 'ipv4-visibility' | awk '{print $2}' | cut -d' ' -f12- |tr -d \%)

        if [ "$VISABILITY" -ge "99" ]; then
#            echo $VISABILITY
            curl -s --max-time 20 -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&text=$PREFIX announced again" $URL >/dev/null
            rm $file
        fi
    fi
done
