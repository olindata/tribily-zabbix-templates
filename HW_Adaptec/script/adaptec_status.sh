#!/bin/bash
# Script to fetch adaptech RAID status for tribily monitoring systems
# Author: krish@tribily.com
# License: GPLv2
#
# Variables
ARCBIN=`which arcconf`
ZBX_SENDER=`which zabbix_sender`
ZBX_CONF="/etc/zabbix/zabbix_agentd.conf"

function zsend {
        $ZBX_SENDER -c $ZBX_CONF -k $1 -o $2
}


# Controller Info
zsend adpt.conmod `$ARCBIN getconfig 1 | grep "Controller Model" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'`

# Temperature
zsend adpt.temp `$ARCBIN getconfig 1 | grep "Temperature" | cut -f2 -d":" | cut -f1 -d"C"`

# Available Logical Devices
zsend adpt.ldevon `$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f1 -d"/"`

# Failed Logical Devices
zsend adpt.ldevfail `$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f2 -d"/"`

# Degraded Logical Devices
zsend adpt.ldevdeg `$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f3 -d"/"`

# Controller Version Information
zsend adpt.bios `$ARCBIN getconfig 1 | grep BIOS | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'`
zsend adpt.firm `$ARCBIN getconfig 1 | grep Firmware | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g' | awk 'NR==1'`
zsend adpt.driver `$ARCBIN getconfig 1 | grep Driver | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'`
zsend adpt.flash `$ARCBIN getconfig 1 | grep "Boot Flash" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'`

# Controller Battery Info
zsend adpt.battery `$ARCBIN getconfig 1 | grep -A3 "Battery Information" | grep Status | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'`

# Logical device info
zsend adpt.raidlevel `$ARCBIN getconfig 1 | grep "RAID level" | cut -f2 -d":"`
zsend adpt.raidsize `$ARCBIN getconfig 1 | grep -A6 "Logical device number" | grep Size | cut -f2 -d":" | awk '{print $1}'`

# Physical device info
# 1st device
zsend adpt.1state `$ARCBIN getconfig 1 | grep -A5 "Device #0" | grep State | cut -f2 -d":"`
zsend adpt.1power `$ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'`
zsend adpt.1smart `$ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "S.M.A.R.T. warning" | cut -f2 -d":"`

# 2nd device
zsend adpt.2state `$ARCBIN getconfig 1 | grep -A5 "Device #1" | grep State | cut -f2 -d":"`
zsend adpt.2power `$ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'`
zsend adpt.2smart `$ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "S.M.A.R.T. warning" | cut -f2 -d":"`

                                                                                                                                                      54,0-1        Bot

