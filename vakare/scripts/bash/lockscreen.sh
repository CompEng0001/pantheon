#! /usr/bin/env bash

# File and path
WALLPAPERPATH="$HOME/Pictures/Wallpaper/"
WALLPAPERD0=".lockscreenEDP1.png"
WALLPAPERD1=".lockscreenHMDI1.png"
WALLPAPERD2=".lockscreenDP1.png"
#Check for multimonitor setup
SCREEN_MODE=$(cat ~/.config/polybar/modules/screens/screens_mode.env)

if [[ ${SCREEN_MODE} == "SINGLE" ]];then
   scrot -D :0 "${WALLPAPERPATH}${WALLPAPERD0}"

   multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" --fx blur
   multilockscreen -l blur
   rm "${WALLPAPERPATH}${WALLPAPERD0}"
elif [[ ${SCREEN_MODE} == "EXTENDED" ]] || [[ ${SCREEN_MODE} == "DUPLICATE" ]];then
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 1 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD0}"
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 2 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD1}"

   multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" -u "${WALLPAPERPATH}${WALLPAPERD1}" --fx blur --display 1 2
   multilockscreen -l blur
   rm "${WALLPAPERPATH}${WALLPAPERD0}" "${WALLPAPERPATH}${WALLPAPERD1}"
elif [[ ${SCREEN_MODE} == "TRI-EXTENDED" ]]; then
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 1 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD0}"
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 2 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD1}"
   scrot -a $( xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 3 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD2}"

   multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" -u "${WALLPAPERPATH}${WALLPAPERD1}" -u "{WALLPAPERPATH}${WALLPAPERD2}" --fx blur --display 1 2 3
   multilockscreen -l blur
   rm "${WALLPAPERPATH}${WALLPAPERD0}" "${WALLPAPERPATH}${WALLPAPERD1}" "${WALLPAPERPATH}${WALLPAPERD2}"
fi
