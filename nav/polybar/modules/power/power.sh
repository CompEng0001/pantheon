#! /usr/bin/env bash
TREM=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "time to empty" | awk '{print$4}')

echo "${TREM} h"
