#! /usr/bin/env bash

MAX=24000
MIN=1000
STEP=1000
ACTUAL=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
BRIGHTNESS="/sys/class/backlight/intel_backlight/brightness"

if [ $1 == "-u" ];then
   if [ ${ACTUAL} -lt ${MAX} ]; then
	echo $((${STEP} + ${ACTUAL})) > ${BRIGHTNESS}
   fi
elif [ $1 == "-d" ];then
     if [ ${ACTUAL} -gt ${MIN} ];then
	echo $((${ACTUAL} - ${STEP})) > ${BRIGHTNESS}
     fi
fi
