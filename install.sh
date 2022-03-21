#! /usr/bin/env bash

#Installer script for dotfiles etc

# /home/user/pantheon
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
STOWCONFIGPATH="$HOME/.config"
MACHINE=$1

softlinks(){
	# create soft links from "dotfiles"
	cd ${MACHINE}

	#config
	echo "stowing directories and/or files"
	for d in $PWD/*
	do
	   echo -e "${d}"
	   BNAME=$(basename ${d})
      	   echo -e "${BNAME}"
	   if [[ ${BNAME} == "bash" ]];then
         	echo "removing .bash*"
		rm ~/.bash*
		echo "stowing:\n stow -Svt ~ bash/"
		stoweth -Svt "~" ${BNAME}
	   elif [[ ${BNAME} == "Wallpaper" ]];then
		dircheck "$HOME/Pictures" "${BASENAME}"
		stoweth "$HOME/Pictures/${BNAME}" "${BNAME}"
           elif [[ ${BNAME} == "nixos" ]];then
		dircheck "/etc" ${BNAME}
                stoweth "/etc/nixos" "${BNAME}"
	   else
		dircheck ${STOWCONFIGPATH} $BNAME
		stoweth "${STOWCONFIGPATH}/${BNAME}" ${BNAME}
	   fi
	done
}

stoweth(){
	stow -Svt "$1" "$2"
}

dircheck()
{
    if [[ ! -d "$1/$2" ]];
          echo creating "$1/$2"
          mkdir "$1/$2"
    else
	  echo "$1/$2  exists, making back up then removing original"
          cp -r $1/$2 $1/$2.bak
	  if [[ $(ls -A $1/$2) ]];then
             rm  $1/$2/* || echo "removed files from $1/$2"
	  fi
   fi
}

machinecheck(){
    case "${MACHINE}" in
	"nav")
	softlinks ${MACHINE}
	;;
	"nisha")
	softlinks ${MACHINE}
	;;
	"nott")
	softlinks ${MACHINE}
	;;
	"nox")
	softlinks ${MACHINE}
	;;
	"nut")
	softlinks ${MACHINE}
	;;
	"nyx")
	softlinks ${MACHINE}
	;;
    esac
}

machinecheck ${MACHINE}
