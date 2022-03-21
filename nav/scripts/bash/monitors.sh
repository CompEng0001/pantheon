#! /usr/bin/env bash

#if [[ $(pgrep polybar | wc -l) -lt 1 ]]; then
#	 exit 0;
#fi
#set -e

pkill polybar > /dev/null

while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

OUTPUT=$(xrandr --query | grep " connected" | cut -d" " -f1)
set -- ${OUTPUT}
tray_output=$1

# change the line number to match the i3 config line.

sed -i "137 c \\set $\monitor_main \"${OUTPUT}\"" ~/.config/i3/config

MONITOR1=${OUTPUT} polybar --reload top -c ~/.config/polybar/config &
MONITOR1=${OUTPUT} polybar --reload bottom -c ~/.config/polybar/config &
feh --bg-center --image-bg "#0000000" --no-xinerama ~/Pictures/Wallpaper/orbital_dance.jpg

export MONITOR1=$1
if [[ $m == $tray_output ]]; then
	TRAY_POSITION=right
fi
