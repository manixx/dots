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
	make
	neovim
	nnn
	pass
	setxkbmap
	tmux
	trash-cli
	xclip
	xcursor-vanilla-dmz-aa
	xinit 
	xorg-minimal
	xrandr
	xrdb 
	xsetroot
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting	
	intel-video-accel
	mesa-dri 
	xf86-video-intel
	chromium
	unclutter
	xbindkeys
	redshift 
	task
)

sudo xbps-install "${packages[@]}"

# TODO install dwm & st

