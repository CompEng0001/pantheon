#! /usr/bin/env bash

#if [[ $(pgrep polybar | wc -l) -lt 1 ]]; then
#	 exit 0;
#fi
#set -e
MONITORS=$(xrandr -q | grep -w connected | awk '{print$1}')
PRIMARYMONITOR=$(echo ${MONITORS} | awk '{print$1}')
WALLPAPER="wallpaper.jpg"
pkill polybar > /dev/null

while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

OUTPUTS=$(xrandr --query | grep " connected" | cut -d" " -f1)
set -- ${OUTPUTS}
tray_output=$1
# check to see if monitor exists

xrandr -s -0
MONITOR1=${PRIMARYMONITOR} polybar --reload eDP1-top -c ~/.config/polybar/config &
MONITOR1=${PRIMARYMONITOR} polybar --reload eDP1-bottom -c ~/.config/polybar/config &
feh --bg-center --image-bg "#0000000" --no-xinerama ~/.config/Wallpaper/${WALLPAPER}

for m in ${OUTPUTS}; do
	export MONITOR1=$1
	if [[ $m == $tray_output ]]; then
		TRAY_POSITION=right
	fi
done
