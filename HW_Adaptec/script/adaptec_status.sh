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
  sudo $ARCBIN getconfig 1 | grep "Controller Model" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Temperature
function adpt.temp {
  sudo $ARCBIN getconfig 1 | grep "Temperature" | cut -f2 -d":" | cut -f1 -d"C" | sed 's/ //' | xargs echo
}

# Available Logical Devices
function adpt.ldevon {
  sudo $ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f1 -d"/" | sed 's/ //'
}

# Failed Logical Devices
function adpt.ldevfail {
  sudo $ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f2 -d"/"
}

# Degraded Logical Devices
function adpt.ldevdeg {
  #sudo $ARCBIN getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f3 -d"/"
  echo 0
}

# Controller Version Information
function adpt.bios {
  sudo $ARCBIN getconfig 1 | grep BIOS | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.firm {
  sudo $ARCBIN getconfig 1 | grep Firmware | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g' | awk 'NR==1'
}

function adpt.driver {
  sudo $ARCBIN getconfig 1 | grep Driver | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.flash {
  sudo $ARCBIN getconfig 1 | grep "Boot Flash" | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Controller Battery Info
function adpt.battery {
  sudo $ARCBIN getconfig 1 | grep -A3 "Battery Information" | grep Status | cut -f2 -d":" | sed -e 's/^ //' | sed -e 's/ /_/g'
}

# Logical device info
function adpt.raidlevel {
  sudo $ARCBIN getconfig 1 | grep "RAID level" | cut -f2 -d":" | sed 's/ //'
}

function adpt.raidsize {
  sudo $ARCBIN getconfig 1 | grep -A6 "Logical device number" | grep Size | cut -f2 -d":" | awk '{print $1}'
}

# Physical device info
# 1st device
function adpt.1state {
  sudo $ARCBIN getconfig 1 | grep -A5 "Device #0" | grep State | cut -f2 -d":" | sed 's/ //'
}

function adpt.1power {
  sudo $ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.1smart {
  sudo $ARCBIN getconfig 1 | grep -A18 "Device #0" | grep "S.M.A.R.T. warning" | cut -f2 -d":" | sed 's/ //'
}

# 2nd device
function adpt.2state {
  sudo $ARCBIN getconfig 1 | grep -A5 "Device #1" | grep State | cut -f2 -d":" | sed 's/ //'
}

function adpt.2power {
  sudo $ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "Power State" | cut -f2 -d":" | head -n1 | sed -e 's/^ //' | sed -e 's/ /_/g'
}

function adpt.2smart {
  sudo $ARCBIN getconfig 1 | grep -A18 "Device #1" | grep "S.M.A.R.T. warning" | cut -f2 -d":" | sed 's/ //'
}

# Version Info -- Edit this part for your own loss
#
function adpt.tribily.ver {
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

