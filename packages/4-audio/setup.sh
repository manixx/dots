#!/bin/sh 

packages=(
  alsa-utils 
) 

sudo pacman -S --needed "${packages[@]}" 

# TODO check pulseaudio and jack! :) 

