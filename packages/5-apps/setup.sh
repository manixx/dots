#!/bin/sh 

packages=(
  openssh 
  chromium 
  firefox 
  pass 
  task 
  telegram-desktop
)

aur_packages=(

)

sudo pacman -S --needed "${packages[@]}"
