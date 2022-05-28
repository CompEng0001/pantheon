#! /usr/bin/env bash


if [[ $1 == "-1" ]];then
	i3-msg "workspace 1; append_layout $HOME/.config/i3/layouts/layout-1.json"
elif [[ $1 == "-2" ]];then
	i3-msg "workspace 1; append_layout $HOME/.config/i3/layouts/layout-2.json"
elif [[ $1 == "-3" ]];then
	i3-msg "workspace 1; append_layout $HOME/.config/i3/layouts/layout-3.json"
elif [[ $1 == "-4" ]];then
	i3-msg "workspace 1; append_layout $HOME/.config/i3/layouts/layout-4.json"
fi
