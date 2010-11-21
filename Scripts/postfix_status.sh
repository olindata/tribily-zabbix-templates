#!/bin/bash -x
# Script to fetch nginx statuses for tribily monitoring systems
# Initial Author: Zabbix Community
# Improvements, Features, Testing: krish@toonheart.com
# License: GPLv2

# Set Variables
MAILLOG=/var/log/maillog
MYLOG=~/tmp/zabbix-postfix.log
DAT1=~/zabbix-postfix-offset.dat
DAT2=$(mktemp)
PFLOGSUMM=/usr/local/sbin/pflogsumm.pl
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf
ZBX_SENDER=`which zabbix_sender`

function zsend {
  $ZBX_SENDER -c $ZABBIX_CONF -k $1 -o $2
}

/usr/sbin/logtail -f$MAILLOG -o$DAT1 | $PFLOGSUMM -h 0 -u 0 --no_bounce_detail --no_deferral_detail --no_reject_detail --no_no_msg_size --no_smtpd_warnings > $DAT2

zsend pfreceived `grep -m 1 received $DAT2|cut -f1 -d"r"`
zsend pfdelivered `grep -m 1 delivered $DAT2|cut -f1 -d"d"`
zsend pfforwarded `grep -m 1 forwarded $DAT2|cut -f1 -d"f"`
zsend pfdeferred `grep -m 1 deferred $DAT2|cut -f1 -d"d"`
zsend pfbounced `grep -m 1 bounced $DAT2|cut -f1 -d"b"`
zsend pfrejected `grep -m 1 rejected $DAT2|cut -f1 -d"r"`
zsend pfrejectwarnings `grep -m 1 "reject warnings" $DAT2|cut -f1 -d"r"`
zsend pfheld `grep -m 1 held $DAT2|cut -f1 -d"h"`
zsend pfdiscarded `grep -m 1 discarded $DAT2|cut -f1 -d"d"`
zsend pfbytesreceived `grep -m 1 "bytes received" $DAT2|cut -f1 -d"b"|cut -f1 -d"k"`
zsend pfbytesdelivered `grep -m 1 "bytes delivered" $DAT2|cut -f1 -d"b"|cut -f1 -d"k"`

rm $DAT2

