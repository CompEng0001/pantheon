#! /usr/bin/env bash


WEATHER=$(curl -sf 'http://wttr.in/Canterbury?format=%l:+%C+%t')

echo ${WEATHER}
