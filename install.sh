#! /usr/bin/env bash

#Installer script for dotfiles etc

STOWCONFIGPATH="$HOME/.config"

MACHINE=$1

cd ~/Git/personal/pantheon/${MACHINE}

stow -Svt ${STOWCONFIGPATH} .
