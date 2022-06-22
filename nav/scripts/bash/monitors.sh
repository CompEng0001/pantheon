#! /usr/bin/env bash

#if [[ $(pgrep polybar | wc -l) -lt 1 ]]; then
#	 exit 0;
#fi
#set -e

SCREENMODEFILE=~/.config/polybar/modules/screens/screens_mode.env
SCREENMODE=$(cat ${SCREENMODEFILE} | awk '{print$1}')
DIRECTION=$(cat ${SCREENMODEFILE} | awk '{print$2}')
RESOLUTION=$(cat ${SCREENMODEFILE} | awk '{print$3}')
MONITORS=$(xrandr -q | grep -w connected | awk '{print$1}')
PRIMARYMONITOR=$(echo ${MONITORS} | awk '{print$1}')
SECONDMONITOR=$(echo ${MONITORS} | awk '{print$2}')
WALLPAPER="wallpaper.jpg"

pkill polybar > /dev/null

while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

OUTPUTS=$(xrandr --query | grep " connected" | cut -d" " -f1)
set -- ${OUTPUTS}
tray_output=$1
SECONDMONITOR=$(echo ${OUTPUTS} | awk '{print$2}')

# check to see if monitor exists
if [[ -z "${SECONDMONITOR}" ]] || [[ ${SCREENMODE} == "SINGLE"  ]];then
	SECONDMONITOR=${PRIMARYMONITOR}
fi

# change the line number to match the i3 config line.

sed -i "138 c \\set $\monitor_secondary \"${SECONDMONITOR}\"" ~/.config/i3/config

if [[ ${SCREENMODE} == "SINGLE" ]];then
	# reset monitor
	xrandr -s -0
	MONITOR1=${PRIMARYMONITOR} polybar --reload eDP1-top -c ~/.config/polybar/config &
 	MONITOR1=${PRIMARYMONITOR} polybar --reload eDP1-bottom -c ~/.config/polybar/config &
	feh --bg-center --image-bg "#0000000" --no-xinerama ~/Pictures/Wallpaper/${WALLPAPER}
elif [[ ${SCREENMODE} == "DUPLICATE" ]]; then
	#xrandr -s -0
	xrandr --output "${SECONDMONITOR}" --mode ${RESOLUTION} "${DIRECTION}" "${PRIMARYMONITOR}"
	for M in ${OUTPUTS}; do
		if [ ${M} == $1 ];then
        		MONITOR1=${M} polybar --reload eDP1-top -c ~/.config/polybar/config &
	        	MONITOR1=${M} polybar --reload eDP1-bottom -c ~/.config/polybar/config &
		fi
	done
	feh --bg-center --image-bg "#0000000" --no-xinerama ~/Pictures/Wallpaper/${WALLPAPER}

elif [[ ${SCREENMODE} == "EXTENDED" ]];then
	xrandr --output "${SECONDMONITOR}" --mode 1920x1080 "${DIRECTION}" "${PRIMARYMONITOR}"
	for M in ${OUTPUTS}; do
		if [ ${M} == $1 ];then
        		MONITOR1=${M} polybar --reload eDP1-top -c ~/.config/polybar/config &
	        	MONITOR1=${M} polybar --reload eDP1-bottom -c ~/.config/polybar/config &
		elif [ ${M} == $2 ];then
			MONITOR2=${M} polybar --reload HDMI1-top -c ~/.config/polybar/config &
			MONITOR2=${M} polybar --reload HDMI1-bottom -c ~/.config/polybar/config &
		fi
	done
	feh --bg-center --image-bg "#0000000" --no-xinerama ~/Pictures/Wallpaper/portal.jpg
fi

for m in ${OUTPUTS}; do
	export MONITOR1=$1
	export MONITOR2=$2
        if [[ $m == $tray_output ]]; then
        	TRAY_POSITION=right
        fi
done
