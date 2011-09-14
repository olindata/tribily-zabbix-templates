#!/bin/bash
#
#Dirty script for asterisk status made during testing
# Variables
ZBX_SENDER=`which zabbix_sender`
ZBX_CONF="/etc/zabbix/zabbix_agentd.conf"
#
# General Stats

$ZBX_SENDER -c $ZBX_CONF -k ast.pid -o `cat /var/run/asterisk/asterisk.pid`
$ZBX_SENDER -c $ZBX_CONF -k ast.uptime -o `asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep uptime | cut -f2 -d: | sed 's/ //g'`
$ZBX_SENDER -c $ZBX_CONF -k ast.reloadtime -o `asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep reload | cut -f2 -d: | sed 's/ //g'`
$ZBX_SENDER -c $ZBX_CONF -k ast.version -o `asterisk /usr/sbin/asterisk -V | cut -f2 -d' '`


# Core Stats

$ZBX_SENDER -c $ZBX_CONF -k ast.activecalls -o `asterisk /usr/sbin/asterisk -rvvvvvx 'core show calls'| grep -i --text 'active' | awk '{print $1}'`
$ZBX_SENDER -c $ZBX_CONF -k ast.callsdone -o `asterisk /usr/sbin/asterisk -rvvvvvx 'core show calls'| grep -i --text 'processed' | awk '{print $1}'`


# IAX2 Stats

$ZBX_SENDER -c $ZBX_CONF -k iax.status -o `asterisk /usr/sbin/asterisk -rvvvvvx 'iax2 show registry'|grep Registered |wc -l`
$ZBX_SENDER -c $ZBX_CONF -k iax.channels -o `asterisk -rvvvvvx 'iax2 show channels'|grep --text -i 'active IAX channel'|awk '{print $1}'`



# SIP Stats

$ZBX_SENDER -c $ZBX_CONF -k sip.status -o `asterisk -rvvvvvx 'sip show registry'|grep Registered |wc -l`
$ZBX_SENDER -c $ZBX_CONF -k sip.peersonline -o `asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $5}'`
$ZBX_SENDER -c $ZBX_CONF -k sip.peersoffline -o `asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $7}'`
$ZBX_SENDER -c $ZBX_CONF -k sip.peers -o `asterisk -rvvvvvx 'sip show peers'|grep --text -i 'sip peers'|awk '{print $1}'`


# DNS Manager

$ZBX_SENDER -c $ZBX_CONF -k dns.status -o `asterisk -rvvvvvx 'dnsmgr status' | grep 'DNS Manager' | awk '{print $NF}'`
$ZBX_SENDER -c $ZBX_CONF -k dns.entries -o `asterisk -rvvvvvx 'dnsmgr status' | grep 'Number of entries' | awk '{print $NF}`




# FAX Stats

$ZBX_SENDER -c $ZBX_CONF -k fax.sessions -o `asterisk -rvvvvvx 'fax show stats' | grep 'Current Sessions' | awk '{print $NF}'`
$ZBX_SENDER -c $ZBX_CONF -k fax.transmits -o `asterisk -rvvvvvx 'Transmit Attempts' | grep 'Current Sessions' | awk '{print $NF}'`
$ZBX_SENDER -c $ZBX_CONF -k fax.receive -o `asterisk -rvvvvvx 'Receive Attempts' | grep 'Current Sessions' | awk '{print $NF}'`
$ZBX_SENDER -c $ZBX_CONF -k fax.done -o `asterisk -rvvvvvx 'Completed' | grep 'Current Sessions' | awk '{print $NF}'`
$ZBX_SENDER -c $ZBX_CONF -k fax.fail -o `asterisk -rvvvvvx 'Failed' | grep 'Current Sessions' | awk '{print $NF}'`




# Parked Calls

$ZBX_SENDER -c $ZBX_CONF -k ast.parkedcalls -o `asterisk -rvvvvvx 'parkedcalls show' | grep 'parked calls in total' | awk '{print $1}'`


