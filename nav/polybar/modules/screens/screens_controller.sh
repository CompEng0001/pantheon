#! /usr/bin/env bash
divider="---------"
MONITORS=$(xrandr -q | grep -w connected | awk '{print$1}' | cut -d" " -f1)
PRIMARYMONITOR=$(echo ${MONITORS} | awk '{print$1}')
SECONDARYMONITOR=$(echo ${MONITORS} | awk '{print$2}')
SCREENMODEFILE=~/.config/polybar/modules/screens/screens_mode.env
SCREENMODE=$(cat ${SCREENMODEFILE} | awk '{print$1}')
DIRECTION=$(cat ${SCREENMODEFILE} | awk '{print$2}')

select_main_monitor(){
    echo "SINGLE" > ${SCREENMODEFILE}
    i3-msg restart
}

duplicate_main_monitor(){
    echo "DUPLICATE $1" > ${SCREENMODEFILE}
    i3-msg restart
}

extend_main_monitor(){
    echo "EXTENDED $1" > ${SCREENMODEFILE}
    i3-msg restart
}


show_menu(){
	local main="${PRIMARYMONITOR} only =  "
	local duplicate="${PRIMARYMONITOR} dup ${SECONDARYMONITOR} =  "
	local extendLeft="${PRIMARYMONITOR} ext ${SECONDARYMONITOR} =  <- "
        local extendRight="${PRIMARYMONITOR} ext ${SECONDARYMONITOR} =  ->  "
	if [ -z ${SECONDARYMONITOR} ];then
		options="Dectected monitors: ${MONITORS}\n${divider}\n${main}\nExit"
	else		options="Dectected monitors:${MONITORS}\n${divider}\n${main}\n${duplicate}\n${extendLeft}\n${extendRight}\nExit"
	fi
	# Open rofi menum read chosen option
	local chosen="$(echo -e ${options} | $rofi_command "Monitors")"
	case ${chosen} in
	    "" | ${divider})
	    	echo "No option chosen"
	        ;;
	    $main)
	        select_main_monitor
	        ;;
	    $duplicate)
	        duplicate_main_monitor "--same-as"
	        ;;
	    $extendLeft)
	        extend_main_monitor "--left-of"
	        ;;
	    $extendRight)
	        extend_main_monitor "--right-of"
	        ;;
	esac
}

print_status() {
	# get current screen layout
	if [[ ${SCREENMODE} == "SINGLE" ]];then
		echo ""
	elif [[ ${SCREENMODE} == "EXTENDED" ]] && [[ ${DIRECTION} == "--left-of" ]]; then
	   # EXTENDED MODE
                echo "  <-  "
	elif [[ ${SCREENMODE} == "EXTENDED" ]] && [[ ${DIRECTION} == "--right-of" ]]; then
	   # EXTENDED MODE
                echo " ->  "
	elif [[ ${SCREENMODE} == "DUPLICATE" ]];then
	   # Duplicate MODE
                echo ""
	fi
}


# Rofi command to pipe into, can add options here
rofi_command="rofi -dmenu -no-fixed-num-lines -yoffset -100 -i -p"

case "$1" in
     --status)
         print_status
	 ;;
     *)
	 show_menu
	 ;;
esac