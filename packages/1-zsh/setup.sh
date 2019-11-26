#!/bin/sh 

set -ex 

packages=(
  zsh 
  zsh-completions
  zsh-autosuggestions
  
  # additional tools 
  fzf 
  nnn
  trash-cli

  # for AUR packages 
  git 
  base-devel 
)

aur_packages=(
  zsh-fast-syntax-highlighting-git
)

sudo pacman -S --needed ${packages[@]}
mkdir -p ~/.aur 

for package in "${aur_packages[@]}"; do 
  if [ ! -d ~/.aur/${package} ]; then 
    (cd ~/.aur && \
      git clone https://aur.archlinux.org/${package} && \
      cd ~/.aur/${package} && \
      makepkg -si)
  fi 
done 

chsh -s /bin/zsh

cp ./.zsh{rc,env} ~
trash -f ~/.bash*
