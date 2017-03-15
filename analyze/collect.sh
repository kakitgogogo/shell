#!/bin/bash

INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=/home/kakit/shell/benchmark/running
mysql -u kakit -p131413 -e 'SHOW GLOBAL VARIABLES' >> mysql-variables

while test -e $RUNFILE; do
	file=$(date +%F_%I)
	sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
	sleep $sleep
	ts="$(date +"TS %s.%N %F %T")"
	loadavg="$(uptime)"
	echo "$ts $loadavg" >> $PREFIX-${file}-status
	mysql -u kakit -p131413 -e "SHOW GLOBAL STATUS" >> $PREFIX-${file}-status &
	echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
	mysql -u kakit -p131413 -e "SHOW ENGINE INNODB STATUS\G" >> $PREFIX-${file}-innodbstatus &
	echo "$ts $loadavg" >> $PREFIX-${file}-processlist
	mysql -u kakit -p131413 -e "SHOW FULL PROCESSLIST" >> $PREFIX-${file}-processlist &
	echo $ts
done

echo "done"
