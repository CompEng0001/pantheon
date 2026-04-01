#! /usr/bin/env bash

WALLPAPER_PATH="$HOME/Wallpaper/wallpaper.jpg"

swww-daemon &
sleep 0.25
swww img ${WALLPAPER_PATH}
