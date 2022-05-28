#! /usr/bin/env bash

WALLPAPER=~/.config/Wallpaper/wallpaper.jpg
SCREENMODEFILE=~/.config/polybar/modules/screens/screens_mode.env
RESOLUTION=$(cat ${SCREENMODEFILE} | awk '{print$1}')

pkill polybar > /dev/null


while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

xrandr -s ${RESOLUTION} 
polybar --reload DP1-top -c ~/.config/polybar/config &
polybar --reload DP1-bottom -c ~/.config/polybar/config &
feh --bg-center --image-bg "#221f21" --no-xinerama ${WALLPAPER}
