#! /usr/bin/env bash

# File and path
WALLPAPERPATH="$HOME/Git/personal/pantheon/aitvaras/Wallpaper/"
WALLPAPERD0=".lockscreenEDP1.png"

scrot -D :0 "${WALLPAPERPATH}${WALLPAPERD0}"

multilockscreen -u "${WALLPAPERPATH}${WALLPAPERD0}" --fx blur
multilockscreen -l blur

rm "${WALLPAPERPATH}${WALLPAPERD0}"
