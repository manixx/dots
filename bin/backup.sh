#!/bin/sh 

cp ~/.zsh{env,rc} packages/1-zsh

cp ~/.config/nvim/* packages/2-nvim 

cp ~/.xinitrc \
  ~/.Xresources \
  ~/.config/compton.conf \
  packages/3-xorg 

cp ~/.config/i3/config       packages/3-xorg/i3-config
cp ~/.config/i3status/config packages/3-xorg/i3status-config
