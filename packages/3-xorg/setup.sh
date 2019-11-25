#!/bin/sh 

set -ex

packages=(
  dmenu
  dunst
  feh
  gcc # for .Xresoures parsing 
  i3-gaps
  i3lock
  i3status
  imagemagick
  libnotify
  otf-font-awesome
  redshift
  rxvt-unicode
  scrot
  ttf-dejavu
  unclutter
  urxvt-perls
  xclip
  xf86-video-intel
  xorg-server
  xorg-xbacklight
  xorg-xinit
  xorg-xprop
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
cp i3-config ~/.config/i3/config 

mkdir -p ~/.config/i3status 
cp i3status-config ~/.config/i3status/config

cp compton.conf ~/.config

mkdir -p ~/.config/dunst
cp dunstrc ~/.config/dunst

sudo cp 20-intel.conf /etc/X11/xorg.conf.d

# setup geoclue for redshift 

if ! grep -Fxq "[redshift]" /etc/geoclue/geoclue.conf; then 
  sudo sh -c "cat geoclue-redshift.conf >> /etc/geoclue/geoclue.conf"
fi

if ! grep -Fxq "url=https://location.services.mozilla.com/v1/geolocate?key=geoclue" /etc/geoclue/geoclue.conf; then 
  sudo sed -i 's/\[wifi\]/\[wifi\]\nurl=https:\/\/location.services.mozilla.com\/v1\/geolocate?key=geoclue/' /etc/geoclue/geoclue.conf
fi

sudo systemctl enable avahi-daemon.socket

# setup x11 keymap 

localectl set-x11-keymap de 
