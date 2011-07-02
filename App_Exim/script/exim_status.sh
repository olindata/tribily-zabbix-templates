#!/bin/bash -x
# Script to fetch exim statuses for tribily monitoring systems 
# Author: krish@tribily.com
# License: GPLv2

# Set Variables
EXIMLOG=/var/log/exim4/mainlog
MYLOG=/tmp/exim_status.log
DAT1=/tmp/exim-status-offset.dat
DAT2=$(mktemp)
EXIMSTATS=/usr/sbin/eximstats
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf
ZBX_SENDER=`which zabbix_sender`

function zsend { 
  $ZBX_SENDER -c $ZABBIX_CONF -k $1 -o $2
}

/usr/sbin/logtail -f$EXIMLOG -o$DAT1 | $EXIMSTATS -t0 /var/log/exim4/mainlog > $DAT2 
echo "Errors 0" >> $DAT2

zsend exreceived `grep -m 1 Received $DAT2|awk '{print $3}'`
zsend exdelivered `grep -m 1 Delivered $DAT2|awk '{print $3}'`
zsend exerrors `grep -m 1 Errors $DAT2|awk '{print $3}'`
zsend exbytesreceived `grep -m 1 "Received" $DAT2|awk '{print $2}'`
zsend exbytesdelivered `grep -m 1 "Delivered" $DAT2|awk '{print $2}'`

rm $DAT2
