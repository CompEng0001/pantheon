#! /usr/bin/env bash 
DATEONE="%a %d %b %Y %H:%M:%S" # Fri 18 Feb 2022 16:48:46
DATETWO="%F %R:%S" # 2022-02-18 16:45:59
DATETHREE="%c" #Sat May 9 11:49:47 2020
DATEFOUR="%s" # 1589053840
DATEFORMATFILE="$HOME/.config/polybar/modules/calendar/dateformat.conf"

divider="----------"

select_dateone(){
    echo "${DATEONE}" > ${DATEFORMATFILE}
}

select_datetwo(){
    echo "${DATETWO}" > ${DATEFORMATFILE}
}

select_datethree(){
    echo "${DATETHREE}" > ${DATEFORMATFILE}
}


select_datefour(){
    echo "${DATEFOUR}" > ${DATEFORMATFILE}
}

show_menu()
{
  local dateone=$(date "+${DATEONE}")
  local datetwo=$(date "+${DATETWO}")
  local datethree=$(date "+${DATETHREE}")
  local datefour=$(date "+${DATEFOUR}")

   options="Select Date-Time Format\n${divider}\n${dateone}\n${datetwo}\n${datethree}\n${datefour}\nExit"
 # Open rofi menum read chosen option
   local chosen="$(echo -e ${options} | $rofi_command "Date Formatter")"
   case ${chosen} in
        "" | ${divider})
           echo "No option chosen"
             ;;
        "$dateone")
           select_dateone
             ;;
        $datetwo)
           select_datetwo
             ;;
        $datethree)
           select_datethree
             ;;
        "$datefour")
           select_datefour
             ;;
    esac
}

rofi_command="rofi -dmenu -no-fixed-num-lines -yoffset -100 -i -p"

show_menu