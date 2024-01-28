#! /usr/bin/env bash

~/.config/scripts/bash/lockscreen.sh &

sleep 3

if [[ $1 == '-s' ]]; then

	systemctl suspend

elif [[ $1 == '-h' ]]; then

	systemctl	hibernate

fi