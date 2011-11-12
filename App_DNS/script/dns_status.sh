#!/bin/bash
#
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
