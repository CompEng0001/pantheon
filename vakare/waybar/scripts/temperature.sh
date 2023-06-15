#! /usr/bin/env bash
#
HWMONPATH=/sys/class/hwmon/hwmon

for i in {0..5} ;do
    if [[ $1 == $(cat $HWMONPATH$i/name) ]];then
       temp=$( cat "${HWMONPATH}$i/temp1_input")
       echo ${temp:0:2}
    fi
done
