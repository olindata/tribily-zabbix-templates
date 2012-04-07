#!/bin/bash
# Script to fetch memcached status for tribily monitoring systems
# Author: krish@tribily.com
# Organization: Tribily
# License: GPLv2
# Version: 1.0
#
# Variables
NCBIN=`which nc`
MEMCACHED_SRV="192.168.2.228"
PORT="11211"
VERSION="1.0"

# Check if Memcached is running on specified port
${NCBIN} -z ${MEMCACHED_SRV} ${PORT}
if [ "$?" -ne "0" ]
then
	echo "ERROR: Memcached is not running on ${MEMCACHED_SRV}:${PORT}"
	exit 7
else


# Functions to return memcached statuses
function memchd.pid {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep pid | awk '{print $NF}'
}

function memchd.uptime {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep uptime | awk '{print $NF}'
}

function memchd.version {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep version | awk '{print $NF}'
}

function memchd.rusage_user {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep rusage_user | awk '{print $NF}'
}

function memchd.rusage_system {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep rusage_system | awk '{print $NF}'
}

function memchd.curr_conn {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep curr_connections | awk '{print $NF}'
}

function memchd.total_conn {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep total_connections | awk '{print $NF}'
}

function memchd.conn_struct {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep connection_structures | awk '{print $NF}'
}

#
function memchd.bytes_read {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep bytes_read | awk '{print $NF}'
}

function memchd.bytes_written {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep bytes_written | awk '{print $NF}'
}

function memchd.limit_maxbytes {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep limit_maxbytes | awk '{print $NF}'
}

function memchd.bytes {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep "STAT bytes " | awk '{print $NF}'
}

function memchd.curr_items {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep curr_items | awk '{print $NF}'
}

function memchd.total_items {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep total_items | awk '{print $NF}'
}

function memchd.evictions {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep evictions | awk '{print $NF}'
}

function memchd.get_misses {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep get_misses | awk '{print $NF}'
}

function memchd.get_hits {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep get_hits | awk '{print $NF}'
}

function memchd.cmd_get {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep cmd_get | awk '{print $NF}'
}

function memchd.cmd_set {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep cmd_set | awk '{print $NF}'
}

function memchd.threads {
	echo "stats" | ${NCBIN} -w 1 ${MEMCACHED_SRV} ${PORT} | grep cmd_set | awk '{print $NF}'
}

# Version Info -- Edit this part for your own loss
#
function memchd.tribily.ver {
  echo ${VERSION}
}

# Check args and proceed 
#
if [ ! "$1" ] || [ "$#" -gt "1" ]
then
        echo "Usage: ./memcached_status.sh <statusname>"
        echo "Statusnames can be" 
        echo `cat $0 | grep function | grep -v grep | awk '{print $2}' | grep -v Run` 
        exit 0  
fi

# Run the requested stat
$1

fi



