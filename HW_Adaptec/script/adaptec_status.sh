#!/bin/bash
# Script to fetch adaptech RAID status for tribily monitoring systems
# Author: krish@tribily.com
# Organization: Tribily
# License: GPLv2
# Version: 1.1
#
# Variables
ARCBIN=`which arcconf`
VERSION=1.1

# Functions to return Adaptec stats

# Controller Info
function adpt.conmod {
	$ARCBIN getconfig 1 | grep "Controller Model" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Temperature
function adpt.temp {
	$ARCBIN getconfig 1 | grep "Temperature" | cut -f2 -d":" | cut -f1 -d"C"
}

# Available Logical Devices
function adpt.ldevon {
	$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f1 -d"/"
}

# Failed Logical Devices
function adpt.ldevfail {
	$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f2 -d"/"
}

# Degraded Logical Devices
function adpt.ldevdeg {
	$ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f3 -d"/"
}

# Controller Version Information
function adpt.bios {
	$ARCBIN getconfig 1 | grep BIOS | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.firm {
	$ARCBIN getconfig 1 | grep Firmware | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g' | awk 'NR==1'
}

function adpt.driver {
	$ARCBIN getconfig 1 | grep Driver | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.flash {
	$ARCBIN getconfig 1 | grep "Boot Flash" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Controller Battery Info
function adpt.battery {
	$ARCBIN getconfig 1 | grep -A3 "Battery Information" | grep Status | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Logical device info
function adpt.raidlevel {
	$ARCBIN getconfig 1 | grep "RAID level" | cut -f2 -d":"
}

function adpt.raidsize {
	$ARCBIN getconfig 1 | grep -A6 "Logical device number" | grep Size | cut -f2 -d":" | awk '{print $1}'
}

# Physical device info
# 1st device
function adpt.1state {
	$ARCBIN getconfig 1 | grep -A5 "Device #0" | grep State | cut -f2 -d":"
}

function adpt.1power {
	$ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.1smart {
	$ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "S.M.A.R.T. warning" | cut -f2 -d":"
}

# 2nd device
function adpt.2state {
	$ARCBIN getconfig 1 | grep -A5 "Device #1" | grep State | cut -f2 -d":"
}

function adpt.2power {
	$ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.2smart {
	$ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "S.M.A.R.T. warning" | cut -f2 -d":"
}

# Version Info -- Edit this part for your own loss
#
function adpt.script.ver {
	echo ${VERSION}
}



# Check args and proceed
#
if [ ! "$1" ] || [ "$#" -gt "1" ]
then
        echo "Usage: ./adaptec_status.sh <statusname>"
        echo "Statusnames can be"
				echo `cat $0 | grep function | grep -v grep | awk '{print $2}' | grep -v Run`
        exit 0  
fi


# Run the requested function
$1

