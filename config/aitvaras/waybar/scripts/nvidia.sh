#! /usr/bin/env bash
#
HWMONPATH=/sys/class/hwmon/hwmon

for i in {0..5} ;do
    if [[ "nouveau" == $(cat $HWMONPATH$i/name) ]];then
       if [[ $1 == "t" ]];then
          temp=$( cat "${HWMONPATH}$i/temp1_input")
          echo ${temp:0:2}
       elif [[ $1 == "f" ]];then
          echo $(cat "${HWMONPATH}$i/fan1_input")
       fi
       break
    fi
done
