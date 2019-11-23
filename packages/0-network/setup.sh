#!/bin/sh 

set -ex 

packages=(
  iw 
  wpa_supplicant 
  netctl 
)

sudo pacman -S --needed ${packages[@]}
