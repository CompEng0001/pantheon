#! /usr/bin/env bash

i3-msg "workspace 1; append_layout $HOME/.config/i3/layouts/layout-1.json"
i3-msg "workspace 1; exec alacritty"
i3-msg "workspace 1; exec alacritty" 
i3-msg "workspace 1; exec alacritty"


# check before running as it duplicates...
#WORKSPACES=$(i3-msg -t get_workspaces | grep -oP '"num":.{1,2}' | awk -F ',' {'print$1'}  | grep -oP ':.{1,2}' | awk -F ':' '{print$2}')
#alacritty && alacritty && alacritty
