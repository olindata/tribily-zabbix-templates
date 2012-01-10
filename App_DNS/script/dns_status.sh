#!/bin/bash
# Script to monitor dns query - 1 means working, 0 is not.
# Author: krish@tribily.com
# Organization: Tribily
# Version: 1.1
#
VERSION=1.1

# Variables
ZBX_SENDER=`which zabbix_sender`
ZBX_CONF="/etc/zabbix/zabbix_agentd.conf"

function zsend { 
  $ZBX_SENDER -c $ZBX_CONF -k $1 -o $2
}


LOOKUP=`which host`
WAIT_TIME="5"
EXITSUM=0

if  test -z "$1" 
then
	echo "ERROR: No DNS Server Specified."
	exit;
else
	DNS_SERVER=$1
fi

SITES=("tribily.com" "olindata.com" "oplexing.com")
		
for site in ${SITES[*]}
do
	if [ `$LOOKUP -s -W $WAIT_TIME $site $DNS_SERVER | grep 'has address' | wc -l` -eq 0 ]
	then
		EXITSUM=`expr $EXITSUM + 0`
	else
		EXITSUM=`expr $EXITSUM + 1`
	fi
done
	
if [ $EXITSUM -gt 0 ]
then
	echo 1
else
	echo 0
fi


# The following implementation is to take DNS list in a file.
# Which was abandoned.
#
#if [ -f "$1" ]
#then
#	DNS_LIST=$1
#	for DNS_SERVER in `cat ${$DNS_LIST}`
#	do
#		for site in ${SITES[*]}
#		do
#			if [ `$LOOKUP -s -W $WAIT_TIME $site $DNS_SERVER | grep 'has address' | wc -l` -eq 0 ]
#			then
#				EXITSUM=`expr $EXITSUM + 0`
#			else
#				EXITSUM=`expr $EXITSUM + 1`
#			fi
#		done
#		
#		if [ $EXITSUM -gt 0 ]
#		then
#			echo 1
#		else
#			echo 0
#		fi
#	done
#fi


zsend tribily.dns.ver `echo ${VERSION}`

