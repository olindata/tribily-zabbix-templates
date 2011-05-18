#!/bin/bash
# Script to fetch postgresql statuses for tribily monitoring systems 
# Author: krish@tribily.com
# License: GPLv2

# Functions to return postgresql stats


function version {
                echo `psql --version|head -n1`
        }

function srvprocess {
                PROC_NUM=`psql -d postgres -U tribilyagent -t -c 'select sum(numbackends) from pg_stat_database' 2>/dev/null`
                IS_NUM=`echo $PROC_NUM | grep [0-9]`

                if [ "$IS_NUM" != "" ]
                then
                        if ! [[ "$PROC_NUM" -eq "$IS_NUM" ]]
                        then
                                echo "0"
                        else
                                echo $PROC_NUM
                        fi
                else
                        echo "0"
                fi
        }

function txcommit {
                TX_COMMIT=`psql -d postgres -U tribilyagent -t -c 'select sum(xact_commit) from pg_stat_database' 2>/dev/null`
                IS_NUM=`echo $TX_COMMIT | grep [0-9]`

                if [ "$IS_NUM" != "" ]
                then
                        if ! [[ "$TX_COMMIT" -eq "$IS_NUM" ]]
                        then
                                echo "0"
                        else
                                echo $TX_COMMIT
                        fi
                else
                        echo "0"
                fi
        }

function txrollback {
                TX_ROLL=`psql -d postgres -U tribilyagent -t -c 'select sum(xact_rollback) from pg_stat_database' 2>/dev/null`
                IS_NUM=`echo $TX_ROLL | grep [0-9]`

                if [ "$IS_NUM" != "" ]
                then
                        if ! [[ "$TX_ROLL" =~ "$IS_NUM" ]]
                        then
                                echo "0"
                        else
                                echo $TX_ROLL
                        fi
                else
                        echo "0"
                fi
        }


if [ ! "$1" ] || [ "$#" -gt "1" ]
then
        echo "Usage: ./pg_status.sh <statusname>"
        echo "Statusnames can be version or srvprocess or txcommit or txrollback"
        exit 0
fi


# Run the requested function
$1
