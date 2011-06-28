#!/bin/bash
#
Dirty script for asterisk status made during testing
#
#
/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k iax.status -o `sudo -u asterisk /usr/sbin/asterisk -rvvvvvx 'iax2 show registry'|grep Registered |wc -l`
ast.pid,cat /var/run/asterisk/asterisk.pid
ast.uptime,sudo -u asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep uptime | cut -f2 -d: | sed 's/,//g' | sed -e 's/^/"/' -e 's/$/"/'
ast.reloadtime,sudo -u asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep reload | cut -f2 -d: | sed 's/,//g'



/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k ast.uptime -o `sudo -u asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep uptime | cut -f2 -d: | sed 's/ //g'`
/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k ast.reloadtime -o `sudo -u asterisk /usr/sbin/asterisk -rvvvvvx 'core show uptime' | grep reload | cut -f2 -d: | sed 's/ //g'`
/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k ast.version -o `sudo -u asterisk /usr/sbin/asterisk -V | cut -f2 -d' '`

