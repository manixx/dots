#!/bin/sh 

set -ex 

packages=(
  iw 
  wpa_supplicant 
  netctl 
  dhcpcd
  dnscrypt-proxy 
)

sudo pacman -S --needed ${packages[@]}

if ! grep -Fxq "name_servers=127.0.0.1" /etc/resolvconf.conf; then
  sudo sh -c "echo 'name_servers=127.0.0.1' >> /etc/resolvconf.conf"
fi

sudo systemctl enable dnscrypt-proxy.service
