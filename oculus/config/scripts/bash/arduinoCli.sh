#! /usr/bin/env bash
#
# Useful commands:
#  arduino-cli core update-index
#  arduino-cli board list
#  arduino-cli install arduino:<boardtype/firmware>


if [ $1 == "-c" ];then

   arduino-cli compile -b arduino:avr:uno $2

elif [ $1 == "-u" ];then

   arduino-cli upload -p /dev/ttyACM0 -b arduino:avr:uno $2

elif [ $1 == "-m" ];then

   arduino-cli monitor -p /dev/ttyACM0

fi
