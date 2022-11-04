#!/usr/bin/env bash
divider="--------"

API="https://api.openweathermap.org/data/2.5"

KEY="ca6ce1b61437d92805727403f7a1d6db"
CITY=$(cat ~/.config/polybar/modules/weather/city)
COUNTRY=",GB"
UNITS="METRIC"
SYMBOL="°"

get_icon() {
    case $1 in
        # Icons for weather-icons
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="流";;
        13n) icon="流";;
        50d) icon="敖";;
        50n) icon="敖";;
        *) icon="";;

    esac

    echo $icon
}

show_menu(){
    local canterbury="Canterbury"
    local gillingham="Gillingham"
    local faversham="Faversham"
    local london="London"
    local other="other"

    local options="Locations: Current Location[${CITY}]\n${divider}\n${canterbury}\n${gillingham}\n${faversham}\n${london}\n${other}"

    local chosen="$(echo -e ${options} | ${rofi_command} "Locations")"
    case ${chosen} in
        "" | ${divider})
            print_status
            ;;
        $canterbury)
            CITY="CANTERBURY"
            print_status
            ;;
        $faversham)
            CITY="FAVERSHAM"
            print_status
            ;;
        $gillingham)
            CITY="GILLINGHAM"
            print_status
            ;;
        $london)
            CITY="LONDON"
            print_status
            ;;
        $other)
            ;;
    esac
}

print_status() {
    if [ -n "$CITY" ]; then
        if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
            CITY_PARAM="id=$CITY$COUNTRY"
        else
            CITY_PARAM="q=$CITY$COUNTRY"
        fi

        weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    else
        location=$(curl -sf "https://location.services.mozilla.com/v1/geolocate?key=geoclue")

        if [ -n "$location" ]; then
            location_lat="$(echo "$location" | jq '.location.lat')"
            location_lon="$(echo "$location" | jq '.location.lng')"

            weather=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        fi
    fi

    if [ -n "$weather" ]; then
        weather_desc=$(echo "$weather" | jq -r ".weather[0].description")
        weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
        weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")
        weather_city_name=$(echo "$weather" |jq -r ".name")
        echo $weather_city_name > ~/.config/polybar/modules/weather/city
        echo "$weather_city_name, " "$(get_icon "$weather_icon")" "  $weather_desc", "$weather_temp$SYMBOL"
    fi
}

rofi_command="rofi -dmenu -no-fixed-num-lines -yoffset -100 -i -p"

case "$1" in
    --status)
        print_status
        ;;
    *)
        show_menu
        ;;
esac
