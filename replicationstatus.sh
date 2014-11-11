#!/bin/sh
date >  /home/deploy/db_status.txt
mysql -h toutapp-proddb.c01ai4mq2ltz.us-east-1.rds.amazonaws.com -u root -e"SHOW SLAVE STATUS\G"|grep Seconds_Behind >> /home/deploy/db_status.txt
