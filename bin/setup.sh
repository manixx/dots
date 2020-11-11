#!/bin/bash

#
# setup branches 
# * system (wifi, internet connection, dracut handling)

# * user management (no ui) 
# 	* user and home directory 
# 	* zsh, cli tools 

set -ex

export LIBVA_DRIVER_NAME=iHD

packages=(
	bat 
	chromium
	dejavu-fonts-ttf
	dmenu
	exa
	fd
	font-awesome5
	font-hack-ttf
	fzf
	gcc
	git
	htop
	intel-video-accel
	make
	mesa-dri 
	neovim
	nnn
	pass
	passmenu
	redshift 
	setxkbmap
	task
	tmux
	trash-cli
	urlview
	unclutter
	xbindkeys
	xclip
	xcursor-vanilla-dmz-aa
	xf86-video-intel
	xinit 
	xorg-minimal
	xrandr
	xrdb 
	xsetroot
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting	
)

sudo xbps-install "${packages[@]}"

# TODO install dwm & st

