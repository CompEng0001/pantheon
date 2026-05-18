#!/usr/bin/env bash

current=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused==true) | .name')

if [[ "$current" == "shared" ]]; then
    niri msg action move-window-to-workspace "1"
    niri msg action focus-workspace "1"
else
    niri msg action move-window-to-workspace "shared"
    niri msg action focus-workspace "shared"
fi
