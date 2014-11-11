#!/bin/bash
AUTH="0f781b3c91579fff8fbead396e1fc6"
CURL="/usr/bin/curl"
URLBASE="https://api.hipchat.com/v1/rooms/message"
HIPCHAT_ROOM="Monitoring"
PATTERN="status"
LIMIT=900
ALARMSTATUS="red"
PDBEG='curl -H "Content-type: application/json" -X POST  -d '"'{ "'"service_key": "5c0050adfd9644a49333571e595fd656",'
TRIGGERTIME=`date`
PDEND='"client":"replication_alarm.sh","client_url":"http://www1.toutapp.com", "details":{"trigger_time":"'"$TRIGGERTIME"'"}}'"' > "'https://events.pagerduty.com/generic/2010-04-15/create_event.json'

# Parse the passed args
while getopts d flag; do
    case $flag in
      d)
        DEBUG="true"
        ;;
      \?)
         echo "Invalid option: $OPTARG" >&2
         exit
         ;;
     esac
done
shift $(( OPTIND - 1 ))

MESSAGE=`tail -2 /home/deploy/db_status.txt | tr -d '\n'| sed 's/ /%20/g'|sed 's/:/%3A/g'`

SECONDS=`tail -1 /home/deploy/db_status.txt |cut -d' ' -f10`

if (( SECONDS > LIMIT )); then
  $CURL "$URLBASE?room_id=$HIPCHAT_ROOM&notify=1&color=red&from=MonitorMan&auth_token=$AUTH&message=$MESSAGE" > /tmp/hipchat 2>/dev/null
  if [ ! -f  "/home/deploy/reptrigger" ]; then
     $PDBEG '"incident_key": "mysql/HTTP", "event_type": "trigger", "description":"Prod db replicas are behind by '$SECONDS' sec", '$PDEND
  fi
  touch /home/deploy/reptrigger
elif [ "$DEBUG" == "true" ]; then
  $CURL "$URLBASE?room_id=$HIPCHAT_ROOM&notify=1&color=red&from=MonitorMan&auth_token=$AUTH&message=TEST%20$MESSAGE" > /tmp/hipchat 2>/dev/null
  $PDBEG '"incident_key": "mysql/HTTP", "event_type": "trigger", "description":"TEST Prod db replicas are behind by '$SECONDS' sec", '$PDEND
fi

