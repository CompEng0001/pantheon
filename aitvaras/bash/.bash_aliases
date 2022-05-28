#GIT
alias gst="git status"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gpl="git pull"
alias gps="git push"
gc ()
{
  git clone git@github.com:"$1""/""$2"
}
alias submoduleUpdate='bash $HOME/PhD/scripts/UtilityScripts/SubmoduleUpdate.sh'

#APPLICATIONS
alias signal="(signal-desktop &) && (sleep 6 && exit)"
alias brave="(brave &) && (sleep 3 && exit)"
alias spotify="(snap run spotify &) && (sleep 3 && exit)"
alias capture="(echo '5 seconds till caputure...') && (sleep 5) && (flameshot gui)"

alias meetingTemplate="bash $HOME/PhD/scripts/UtilityScripts/meetingTemplate.sh"

#SCRIPTS
alias aliases="nano ~/.bash_aliases"
alias bashrc="nano ~/.bashrc"
alias passcode="$HOME/.OTP/passcodes.py"
alias stowth="stow -vSt ~ $1"
alias unstow="stow -vDt ~ $1"
alias digital="bash University/CCCU/CCCUTeaching/21-22/FCC/Digital.sh"

#SYSTEMSTUFF
alias ls="lsd"
alias layout="~/.config/i3/layouts/layout.sh"
alias off="sudo shutdown -h now"
alias cat="bat -p"
alias cccu="cd ~/Universities/CCCU/"
#alias neofetch="neofetch --ascii /home/seb/Documents/ascii/throuple-ascii-art.txt"
historyStat()
{
   history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

#SSH
alias nox="TERM=xterm ssh pi@192.168.1.87"
alias nott="TERM=xterm ssh pi@192.168.1.174"
alias nisha="TERM=xterm ssh -p 443 pi@10.150.200.120"
alias stnix="TERM=xterm ssh sb1501@stnix.canterbury.ac.uk"

#WIFI
alias scan="iwctl station wlan0 scan && iwctl station wlan0 get-networks"
alias wifi="~/.config/scripts/bash/wifi.sh"

#DOCKER
#alias docker_clean="docker volume rm ; docker rm   ;  docker rmi "
#alias docker_ps="docker ps -a --format "{{,ID}\t{{.Names}}}""
#alias docker_rm_all="docker_stop_all ; docker rm  --force"
#alias docker_exited="docker ps -a | grep Exit | cut -d " " -f 1 | xargs docker rm"
#alias docker_stop_all="docker stop "
