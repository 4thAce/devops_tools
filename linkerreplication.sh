#!/bin/sh
date >>  /home/deploy/db_status.txt
mysql -h ec2-54-81-85-214.compute-1.amazonaws.com -u root -e"SHOW SLAVE STATUS\G"|grep Seconds_Behind >> /home/deploy/db_status.txt
