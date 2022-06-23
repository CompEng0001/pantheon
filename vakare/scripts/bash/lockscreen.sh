#! /usr/bin/env bash

# File and path
WALLPAPERPATH="$HOME/Pictures/Wallpaper/"
WALLPAPERD0=".lockscreenEDP1.png"
WALLPAPERD1=".lockscreenHMDI1.png"

#Check for multimonitor setup
SCREEN_MODE=$(cat ~/.config/polybar/modules/screens/screens_mode.env)

if [[ ${SCREEN_MODE} == "SINGLE" ]];then
   scrot -D :0 "${WALLPAPERPATH}${WALLPAPERD0}" 

   multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" --fx blur 
   multilockscreen -l blur 
   rm "${WALLPAPERPATH}${WALLPAPERD0}"
else
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 1 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD0}"
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 2 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD1}"

   multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" -u "${WALLPAPERPATH}${WALLPAPERD1}" --fx blur --display 1 2
   multilockscreen -l blur 
   rm "${WALLPAPERPATH}${WALLPAPERD0}" "${WALLPAPERPATH}${WALLPAPERD1}"
fi
