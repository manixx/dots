#!/bin/sh 

set -ex

packages=(
  dmenu
  dunst
  feh
  i3-gaps
  i3lock
  i3status
  libnotify
  imagemagick
  otf-font-awesome
  rxvt-unicode
  scrot
  ttf-dejavu
  unclutter
  urxvt-perls
  xf86-video-intel
  xorg-server
  xorg-xbacklight
  xorg-xinit
  xorg-xrandr
)

aur_packages=(
  compton-tryone-git
)

sudo pacman -S --needed ${packages[@]}

# install aur packages 
mkdir -p ~/.aur
for package in "${aur_packages[@]}"; do 
  if [ ! -d ~/.aur/${package} ]; then 
    (cd ~/.aur && git clone https://aur.archlinux.org/${package}) 
    (cd ~/.aur/${package} && makepkg -si) 
  fi
done

# move config files 

cp .xinitrc \
  .Xresources \
  ~ 

mkdir -p ~/.config/i3 
cp i3-config ~/.config/i3 

mkdir -p ~/.config/i3status 
cp i3status-config ~/.config/i3status 
