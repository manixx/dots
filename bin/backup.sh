#!/bin/sh 

cp ~/.zsh{env,rc} zsh

cp ~/.config/nvim/* nvim 

cp ~/.xinitrc \
  ~/.Xresources \
  ~/.config/compton.conf \
  xorg 

cp ~/.config/i3/config       xorg/i3-config
cp ~/.config/i3status/config xorg/i3status-config
cp ~/.config/dunst/dunstrc   xorg
