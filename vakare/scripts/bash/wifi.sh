#! /usr/bin/env bash

IWDDIR="/var/lib/iwd/"
declare -A networks
networks=(["-e"]=eduroam.8021x ["-s"]=Southeastern_WiFi.open ["-p"]=CompEng0001.psk ["-N"]=TNCAP52FC59.psk
	["-m"]=makerspace.psk ["-M"]=MACKNADE-FREE.open ["-n"]="NHS Wi-Fi.open" ["-f"]=HometelecomD2MZ5G.psk ["-r"]=BT-FNASJ9.psk)

usage()
{
   echo -e "wifi:\n\t-e eduroam [--gre || --cccu]"
   echo -e "\t-s Southeastern_WiFi\n\t-p CompEng0001\n\t-n NHS_Medway"
   echo -e "\t-m makerspace\n\t-M Macknade\n\t-f flat\n\t-r parents\n\t-N Naomi's"
   echo -e "\t--print [-network --print]\n\t--edit [-network --edit]"
   echo -e "\t-R restart iwd.service"
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
	elif [[ $1 == -M ]]; then
		iwctl station wlan0 connect $(echo ${networks[-M]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -n ]]; then
		iwctl station wlan0 connect "$(echo ${networks[-n]} | awk -F '.' '{print$NR}')"
	elif [[ $1 == -f ]]; then
		iwctl station wlan0 connect $(echo ${networks[-f]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -N ]]; then
		iwctl station wlan0 connect $(echo ${networks[-N]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -r ]]; then
		iwctl station wlan0 connect $(echo ${networks[-r]} | awk -F '.' '{print$NR}')
	elif [[ $1 == -R ]]; then
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
