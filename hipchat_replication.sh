#!/bin/sh
AUTH="0f781b3c91579fff8fbead396e1fc6"
CURL="/usr/bin/curl"
URLBASE="https://api.hipchat.com/v1/rooms/message"
HIPCHAT_ROOM="Monitoring"

MESSAGE=`tail -2 /home/deploy/db_status.txt | tr -d '\n'| sed 's/ /%20/g'|sed 's/:/%3A/g'`

$CURL "$URLBASE?room_id=$HIPCHAT_ROOM&notify=1&color=red&from=MonitorMan&auth_token=$AUTH&message=$MESSAGE" > /tmp/hipchat

