#!/bin/sh 

packages=(
  openssh 
  chromium 
  firefox 
  pass 
  task 
)

sudo pacman -S --needed "${packages[@]}"
