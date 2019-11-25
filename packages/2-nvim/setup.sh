#!/bin/zsh 

set -ex 

packages=(
  neovim 
  nodejs
  npm
  git
  the_silver_searcher
)

coc_extensions=(
  coc-json
  coc-tsserver
  coc-html
  coc-css
  coc-phpls
  coc-java
  coc-rls
  coc-rust-analyzer
  coc-r-lsp
  coc-yaml
  coc-python
  coc-highlight
  coc-snippets
  coc-lists
  coc-git
  coc-yank
  coc-svg
  coc-angular
  coc-xml
  coc-flutter
  coc-markdownlint
)

aur_packages=(
  ccls
)

npm_packages=(
  dockerfile-language-server-nodejs
  bash-language-server
  neovim
)

sudo pacman -S --needed ${packages[@]}

# copy config 
mkdir -p ~/.config/nvim
cp ./* ~/.config/nvim

# install vim-plug 
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

# install aur 
mkdir -p ~/.aur 
for package in "${aur_packages}"; do 
  if [ ! -d ~/.aur/${package} ]; then 
    (cd ~/.aur && git clone https://aur.archlinux.org/${package})
    (cd ~/.aur/${package} && makepkg -si)
  fi
done


