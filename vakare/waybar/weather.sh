#! /usr/bin/env bash


WEATHER=$(curl -sf 'http://wttr.in/Gillingham?format=%l:+%C+%t')

echo ${WEATHER}
