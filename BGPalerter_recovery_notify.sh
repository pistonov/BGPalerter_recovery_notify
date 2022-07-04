#!/bin/bash

#
LOG_FILE="/home/BGPalerter/logs/reports.log"

TELEGRAM_BOT_KEY="bot<_BOT_ID_>"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_KEY/sendMessage"
TELEGRAM_CHAT_ID="_CHAT_ID_"
#

NOW=$(date +%s)

LAST_LOG=$(($NOW - $(date +%s -r $LOG_FILE)))

if [ "$LAST_LOG" -le "121" ]; then

    PATERN=$(cat $LOG_FILE | grep "has been withdrawn")

    while read -r line; do
        LOG_TIME=$(echo $line | cut -d' ' -f1)
        LOG_TIME=$(date -d$LOG_TIME +'%s')
        LOG_TIME=$(($NOW - $LOG_TIME))
        if [ "$LOG_TIME" -le "121" ]; then
            PREFIX_ALERT=$(echo $line | cut -d' ' -f5)
            PREFIX_MASK=$(echo "bgp_"$PREFIX_ALERT | sed -r 's/\//_/g')
            echo $PREFIX_ALERT > /tmp/$PREFIX_MASK
        fi
    done <<< "$PATERN"
fi

for file in /tmp/bgp_* ; do
    if [ -f $file ]; then
        PREFIX=$(cat $file)
        PEER_COUNT=$(curl -s --max-time $TIME https://stat.ripe.net/data/looking-glass/data.json?resource=$PREFIX | jq '.data.rrcs[].peers' | jq '.[].peer' | wc -l)

        if [ "$PEER_COUNT" -ge "200" ]; then
            curl -s --max-time $TIME -d "chat_id=$GROUP_ID&disable_web_page_preview=1&text=$PREFIX announced again" $URL >/dev/null
            rm $file
        fi
    fi
done
