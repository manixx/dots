#!/bin/bash 

set -ex

packages=(
  alsa-utils 
  base-devel 
  chromium 
  dhcpcd
  dmenu
  dunst
  feh
  firefox 
  fzf 
  gcc # for .Xresoures parsing 
  git
  git 
  i3-gaps
  i3lock
  i3status
  imagemagick
  iw 
  libnotify
  netctl 
  nnn
  nmap
  nodejs
  npm
  openssh 
  otf-font-awesome
  pass 
  perl-anyevent-i3
  python
  python-pip
  python2
  python2-pip
  redshift
  ruby 
  rxvt-unicode
  scrot
  task 
  telegram-desktop
  the_silver_searcher
  trash-cli
  ttf-dejavu
  unclutter
  urxvt-perls
  wpa_supplicant 
  xclip
  xf86-video-intel
  xorg-server
  xorg-xbacklight
  xorg-xinit
  xorg-xprop
  xorg-xrandr
  zsh 
  zsh-autosuggestions
  zsh-completions
)

aur_packages=(
  ccls
  compton-tryone-git
  zsh-fast-syntax-highlighting-git
  spotify 
)

coc_extensions=(
  coc-angular
  coc-css
  coc-flutter
  coc-git
  coc-highlight
  coc-html
  coc-java
  coc-json
  coc-lists
  coc-markdownlint
  coc-phpls
  coc-python
  coc-r-lsp
  coc-rls
  coc-rust-analyzer
  coc-snippets
  coc-svg
  coc-tsserver
  coc-xml
  coc-yaml
  coc-yank
)

npm_packages=(
  bash-language-server
  dockerfile-language-server-nodejs
  neovim
)

sudo pacman -S --needed ${packages[@]}

#
# setup AUR 
#

# assign spotify gpg key 
gpg --recv-keys 4773BD5E130D1D45

mkdir -p ~/.aur
for package in "${aur_packages[@]}"; do 
  if [ ! -d ~/.aur/${package} ]; then 
    (cd ~/.aur && git clone https://aur.archlinux.org/${package}) 
    (cd ~/.aur/${package} && makepkg -si) 
  fi
done

#
# setup zsh 
# 

cp ./zsh/.zsh{rc,env} ~

chsh -s /bin/zsh

#
# setup nvim 
# 

mkdir -p ~/.config/nvim
cp ./nvim/* ~/.config/nvim

gem install neovim
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +"PlugInstall --sync" +qa

# install coc extensions 
for extension in "${coc_extensions[@]}"; do 
  nvim +"CocInstall -sync ${extension}" +qa
done

# setup npm 
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

npm i -g ${npm_packages[@]}

#
# setup dnscrypt-proxy 
# 

if ! grep -Fxq "name_servers=127.0.0.1" /etc/resolvconf.conf; then
  sudo "echo 'name_servers=127.0.0.1' >> /etc/resolvconf.conf"
fi

sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start  dnscrypt-proxy.service

#
# setup xorg 
# 

cp ./xorg/.xinitrc \
  ./xorg/.Xresources \
  ~ 

mkdir -p ~/.config/i3 
cp ./xorg/i3-config ~/.config/i3/config 

mkdir -p ~/.config/i3status 
cp ./xorg/i3status-config ~/.config/i3status/config

cp ./xorg/compton.conf ~/.config

mkdir -p ~/.config/dunst
cp ./xorg/dunstrc ~/.config/dunst

sudo cp \
  ./xorg/20-intel.conf \
  ./xorg/30-touchpad.conf \
  /etc/X11/xorg.conf.d

# setup geoclue for redshift 

if ! grep -Fxq "[redshift]" /etc/geoclue/geoclue.conf; then 
  sudo sh -c "cat geoclue-redshift.conf >> /etc/geoclue/geoclue.conf"
fi

if ! grep -Fxq "url=https://location.services.mozilla.com/v1/geolocate?key=geoclue" /etc/geoclue/geoclue.conf; then 
  sudo sed -i 's/\[wifi\]/\[wifi\]\nurl=https:\/\/location.services.mozilla.com\/v1\/geolocate?key=geoclue/' /etc/geoclue/geoclue.conf
fi
