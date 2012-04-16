#!/bin/bash
#
# Script to fetch Asterisk status for tribily monitoring systems
# Author: krish@tribily.com
# License: GPLv2


# Variables
ZBX_SENDER=`which zabbix_sender`
ZBX_CONF="/etc/zabbix/zabbix_agentd.conf"
VERSION="1.0"
#

function zsend {
  $ZBX_SENDER -c $ZBX_CONF -k $1 -o $2
}


# General Stats

zsend ast.pid `sudo -u zabbix sudo cat /var/run/asterisk/asterisk.pid`
zsend ast.uptime `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep uptime | cut -f2 -d: | sed 's/ //g'`
zsend ast.reloadtime `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep reload | cut -f2 -d: | sed 's/ //g'`
zsend ast.version `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -V | cut -f2 -d' '`


# Core Stats
# INFO: Active Calls is Buggy yet.
#zsend ast.activecalls `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -rvvvvvx 'core show calls'| grep -i 'active' | awk '{print $1}'`
zsend ast.callsdone `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -rvvvvvx 'core show calls'| grep -i 'processed' | awk '{print $1}'`



# IAX2 Stats

zsend iax.status `sudo -u zabbix sudo asterisk /usr/sbin/asterisk -rvvvvvx 'iax2 show registry'|grep Registered |wc -l`
zsend iax.channels `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'iax2 show channels'|grep --text -i 'active IAX channel'|awk '{print $1}'`



# SIP Stats

zsend sip.status `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'sip show registry'|grep Registered |wc -l`
zsend sip.peersonline `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $5}'`
zsend sip.peersoffline `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $7}'`
zsend sip.peers `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $1}'`


# DNS Manager

zsend dns.status `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'dnsmgr status' | grep 'DNS Manager' | awk '{print $NF}'`
zsend dns.entries `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'dnsmgr status' | grep 'Number of entries' | awk '{print $NF}'`


# FAX Stats

zsend fax.sessions `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'fax show stats' | grep 'Current Sessions' | awk '{print $NF}'`
zsend fax.transmits `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'fax show stats' | grep 'Transmit Attempts' | awk '{print $NF}'`
zsend fax.receive `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'fax show stats' | grep 'Receive Attempts' | awk '{print $NF}'`
zsend fax.done `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'fax show stats' | grep 'Completed' | awk '{print $NF}'`
zsend fax.fail `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'fax show stats' | grep 'Failed' | awk '{print $NF}'`



# Parked Calls

zsend ast.parkedcalls `sudo -u zabbix sudo /usr/sbin/asterisk -rvvvvvx 'parkedcalls show' | grep 'parked calls in total' | awk '{print $1}'`


# Version information
# Version Info -- Edit this part for your own loss
#
zsend ast.tribily.ver `sudo -u zabbix sudo echo ${VERSION}`
