#! /usr/bin/env bash
divider="---------"
SCREENMODEFILE=~/.config/polybar/modules/screens/screens_mode.env
MONITORS=$(xrandr -q | grep -w connected | awk '{print$1}' | cut -d" " -f1)
D1RESOLUTION=$(xrandr -q | grep -A1 'DP-1' | awk -F '+' 'NR%2==1 {print$1}' | awk '{print$3}')
D2RESOLUTION=$(xrandr -q | grep -A1 'HDMI-2' | awk -F '+' 'NR%2==1 {print$1}' | awk '{print$3}')

select_1920_1200(){
    echo "1920x1200" "${D2RESOLUTION}" > ${SCREENMODEFILE}
    i3-msg restart
}

select_1920_1080(){
    echo "1920x1080" "${D2RESOLUTION}" > ${SCREENMODEFILE}
    i3-msg restart
}
select_3840_1200(){
    echo "3840x1200" "${D2RESOLTION}" > ${SCREENMODEFILE}
    i3-msg restart
}

show_menu(){
    local res_3840_1200="3840x1200"
    local res_1920_1200="1920x1200"
    local res_1920_1080="1920x1080"

    options="Current resolution: ${MONITORS} ${RESOLUTION}\n${divider}\n${res_3840_1200}\n${res_1920_1200}\n${res_1920_1080}\nExit"

	# Open rofi menum read chosen option
	local chosen="$(echo -e ${options} | $rofi_command "Resolutions")"
	case ${chosen} in
	    "" | ${divider})
		echo "No option chosen"
		;;
	    $res_3840_1200)
		select_3840_1200
		;;
	    $res_1920_1200)
		select_1920_1200
		;;
	    $res_1920_1080)
		select_1920_1080
		;;
	esac
    }

    print_status() {
	# get current screen layout
	echo ""
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
