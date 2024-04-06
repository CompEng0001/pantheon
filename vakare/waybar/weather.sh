#! /usr/bin/env bash

CONFIG_FILE=~/.config/waybar/weather_config

# Define a function to prompt the user for location using rofi
get_location() {
    rofi -dmenu -p "Enter location:" -location 7 -lines 45 -yoffset -30 -xoffset 50 -dmenu -no-fixed-num-lines | awk '{print $1}'
}
#rofi -dmenu -p "Enter location:" -width 30 -lines 5
# Function to read location from config file
read_location_from_config() {
    if [ -f ${CONFIG_FILE} ]; then
        LOCATION=$(head -n 1 ${CONFIG_FILE})
    else
        echo "Config file not found."
        exit 1
    fi
}

# Function to write location to config file
write_location_to_config() {
    echo "$1" > ${CONFIG_FILE}
}

# If no location argument is provided, read from config file or prompt user
if [ -z "$1" ]; then
    if [ -n ${CONFIG_FILE} ]; then
        read_location_from_config
    else
        LOCATION=$(get_location)
        write_location_to_config "$LOCATION"
    fi
else
    LOCATION=$(get_location)
    write_location_to_config "$LOCATION"
fi

# Make the curl request with the specified location
WEATHER=$(curl -sf "http://wttr.in/${LOCATION}?format=%l:+%C+%t+%w")

# Output the weather information
echo "${WEATHER}"
