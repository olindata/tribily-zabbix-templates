#!/bin/bash
#
ARCBIN=`which arcconf`


arcconf getconfig 1 | grep "Controller Model" | cut -f2 -d":"
arcconf getconfig 1 | grep "Temperature" | cut -f2 -d":" | cut -f1 -d"C"

arcconf getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f1 -d"/"
arcconf getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f2 -d"/"
arcconf getconfig 1 | grep "Logical devices\/Failed\/Degraded" | cut -f2 -d":" | cut -f3 -d"/"

# Controller Version Information
arcconf getconfig 1 | grep BIOS | cut -f2 -d":"
arcconf getconfig 1 | grep Firmware | cut -f2 -d":"
arcconf getconfig 1 | grep Driver | cut -f2 -d":"
arcconf getconfig 1 | grep "Boot Flash" | cut -f2 -d":"

# Controller Battery Info
arcconf getconfig 1 | grep -A3 "Battery Information" | grep Status | cut -f2 -d":"

# Logical device info
arcconf getconfig 1 | grep "RAID level" | cut -f2 -d":"
arcconf getconfig 1 | grep -A6 "Logical device number" | grep Size | cut -f2 -d":" | cut -f1

# Physical device info
# 1st device
arcconf getconfig 1 | grep -A5 "Device #0" | grep State | cut -f2 -d":"
arcconf getconfig 1 | grep -A18 "Device #0" | grep "Power State" | cut -f2 -d":"
arcconf getconfig 1 | grep -A18 "Device #0" | grep "S.M.A.R.T. warning" | cut -f2 -d":"

# 2nd device
arcconf getconfig 1 | grep -A5 "Device #1" | grep State | cut -f2 -d":"
arcconf getconfig 1 | grep -A18 "Device #1" | grep "Power State" | cut -f2 -d":"
arcconf getconfig 1 | grep -A18 "Device #1" | grep "S.M.A.R.T. warning" | cut -f2 -d":"

