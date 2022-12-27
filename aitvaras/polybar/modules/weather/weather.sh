#!/usr/bin/env bash
divider="--------"

API="https://api.openweathermap.org/data/2.5"

KEY="ca6ce1b61437d92805727403f7a1d6db"
CITY="Canterbury"
COUNTRY=",GB"
UNITS="METRIC"
SYMBOL="°"
CACHE=$(cat ~/.config/polybar/modules/weather/cache)

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

cache(){

    NOW=$(date +%s)
    local cache_time=$(awk '{print $1}' <<< $CACHE)
    if (( $NOW - $cache_time > 500 )) ;then
        callAPI
        exit 0
    else
        local weather=$(awk '{$1=""; print $0}' <<<  $CACHE )
        echo $weather
        exit 0
    fi
}

callAPI() {
    if [ -n "$CITY" ]; then
        if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
            CITY_PARAM="id=$CITY$COUNTRY"
        else
            CITY_PARAM="q=$CITY$COUNTRY"
        fi

        weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")i

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
        NOW=$(date +%s)
        echo "$weather_city_name, " "$(get_icon "$weather_icon") " "  $weather_desc", "$weather_temp$SYMBOL"
        echo $NOW "$weather_city_name, " "$(get_icon "$weather_icon") " "  $weather_desc", "$weather_temp$SYMBOL" > ~/.config/polybar/modules/weather/cache


    fi
}

cache
