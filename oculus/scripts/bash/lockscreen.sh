#! /usr/bin/env bash

# File and path
WALLPAPERPATH="$HOME/.config/Wallpaper/"
WALLPAPERD0=".lockscreenDP1.png"
WALLPAPERD1=".lockscreenHDMI1.png"

scrot -a $(xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 1 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD0}"

scrot -a $(xrandr | grep '\Wconnected\W' | grep -Po "\d+x\d+\+\d+\+\d+" | sed 's/x/+/' | awk -F "+" '{print $3","$4","$1","$2}' | head -n 2 | tail -n 1) "${WALLPAPERPATH}${WALLPAPERD1}"

multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" -u ${WALLPAPERPATH}${WALLPAPERD1} --fx blur --display 1 2

multilockscreen -l blur

rm "${WALLPAPERPATH}${WALLPAPERD0}" "${WALLPAPERPATH}${WALLPAPERD1}"
