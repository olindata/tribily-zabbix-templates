#!/bin/bash
# Script to fetch haproxy statuses for tribily monitoring systems
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
IPADDR=192.168.1.4
PORT=8010
DATE=`date +%Y%m%d`
LOG="/var/log/zabbix/haproxy_status.log"
cd /opt/tribily/bin/
wget $IPADDR:$PORT/haproxy?stats/\;csv -O haproxy_stats_$DATE.csv -o /dev/null
FILE="/opt/tribily/bin/haproxy_stats_$DATE.csv"

# User Defined Pools on HA
POOL1="GALAXY"

# Write the functions

# Status of Servers
#
function fend_status {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f18 -d,
        }       

function bend_status {
	grep "$POOL1" $FILE | grep BACKEND | cut -f18 -d,
        }       


# Queue Informations
#
function qcur {
	grep "$POOL1" $FILE | grep BACKEND | cut -f3 -d,
	}

function qmax {
	grep "$POOL1" $FILE | grep BACKEND | cut -f4 -d,
	}


# Session Informations
#
function fend_scur {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f5 -d,
	}

function fend_smax {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f6 -d,
	}

function bend_scur {
	grep "$POOL1" $FILE | grep BACKEND | cut -f5 -d,
	}

function bend_smax {
	grep "$POOL1" $FILE | grep BACKEND | cut -f6 -d,
	}

function fend_stot {
	grep "$POOL1" $FILE | grep FRONTEND | cut -f8 -d,
	}

function bend_stot {
	grep "$POOL1" $FILE | grep BACKEND | cut -f8 -d,
	}

# Run the requested function
$1


