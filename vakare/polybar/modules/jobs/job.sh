#! /usr/bin/env bash


MAXTHREADS=125069
MAXPROCESSES=4194304
CURTHREADS=$(ps -eo nlwp | tail -n +2 | awk '{ num_threads += $1 } END { print num_threads }')
CURPROCESS=$(ps -eo nlwp | wc -l)

if [[ $1 == "-c"  ]];then
	echo שּׂ ${CURPROCESS}" " 囹 " "${CURTHREADS}
elif [[ $1 == "-f" ]];then
	echo "שּׂ ${CURPROCESS}/${MAXPROCESSES}" " 囹" "${CURTHREADS}/${MAXTHREADS}"
fi
