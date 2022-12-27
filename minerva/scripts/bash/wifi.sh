#! /usr/bin/env bash

IWDDIR="/var/lib/iwd/"
declare -A networks
networks=(["-e"]=eduroam.8021x ["-s"]=Southeastern_WiFi.open ["-p"]=CompEng0001.psk
	["-m"]=makerspace.psk ["-h"]=BT-73CPM3.psk ["-n"]="NHS Wi-Fi.open" ["-hg"]="BT_Mini_Hub_6352_2.4GHz" ["-f"]=HometelecomD2MZ5G.psk)

usage()
{
   echo -e "wifi:\n\t-e eduroam [--gre || --cccu]"
   echo -e "\t-s Southeastern_WiFi\n\t-p CompEng0001\n\t-n NHS_Medway"
   echo -e "\t-m makerspace\n\t-h BT-73CPM3\n\t-hg BT_Mini_Hub_6352_2.4Hz"
   echo -e "\t-f flat\n"
   echo -e "\t--print [-network --print]\n\t--edit [-network --edit]"
   echo -e "\t-r restart iwd.service"
   echo -e "\tNOTE   *check /var/lib/iwd/ or use iwctl*"
}

connection(){
	iwctl station wlan0 scan
	if   [[ $1 == -e ]];then
		iwctl station wlan0 connect $(echo ${networks[-e]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -s ]];then
		iwctl station wlan0 connect $(echo ${networks[-s]} | awk -F '.' '{print$NR}')
		xdg-open https://southeastern.on.icomera.com
	elif [[ $1 == -p ]];then
		iwctl station wlan0 connect $(echo ${networks[-p]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -m ]]; then
		iwctl station wlan0 connect $(echo ${networks[-m]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -n ]]; then
		iwctl station wlan0 connect "$(echo ${networks[-n]} | awk -F '.' '{print$NR}')"
	elif [[ $1 == -h ]]; then
		iwctl station wlan0 connect $(echo ${networks[-h]} | awk -F '.' '{print$NR}'| awk -F '.' '{print$NR}')
	elif [[ $1 == -hg ]]; then
		iwctl station wlan0 connect ${networks[-hg]}
	elif [[ $1 == -f ]]; then
		iwctl station wlan0 connenct ${networks[-f]}
	elif [[ $1 == -r ]]; then
		sudo systemctl restart iwd.service
	fi
}

edit(){
	sudo nano ${IWDDIR}${networks["$1"]}
}

print(){
	sudo cat ${IWDDIR}${networks["$1"]}
}


if   [[  $# -lt 1 ]]; then
	usage
elif [[ $# -eq 1 ]];then
	connection $1
elif [[ $# -eq 2 ]]; then
	if   [[ $2 == "--print" ]]; then
		print $1
	elif [[ $2 == "--edit" ]]; then
		edit $1
	elif [[ $2 == "--gre" ]];then
		sudo cp "${IWDDIR}eduroam.gre" "${IWDDIR}eduroam.8021x"
		connection $1
	elif [[ $2 == "--cccu" ]];then
		sudo cp "${IWDDIR}eduroam.cccu" "${IWDDIR}eduroam.8021x"
		connection $1
	else
		usage
	fi
else
	usage
fi
