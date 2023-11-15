#! /usr/bin/env bash


PLAYER=spotify
STATUS=""
METADATA=""
POSITION=""

getStatus()
{
   STATUS=$(playerctl --player=${PLAYER} status 2>&1)
}

getMetadata()
{
   POSITION=$(playerctl --player=${PLAYER} position --format "{{ duration(position) }}" 2>&1)
   METADATA=$(playerctl --player=${PLAYER} metadata --format "${STATUS}: {{ artist }} - {{ album }} - {{ title }} ${POSITION}/{{ duration(mpris:length) }}" | sed -e 's/&/and/g'  2>&1)
}

getStatus

if [[ ${STATUS} == "No players found" ]]; then
     echo "Spotify - Offline"

else
   getMetadata
   echo ${METADATA}
fi
