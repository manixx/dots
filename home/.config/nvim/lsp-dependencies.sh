#!/bin/zsh

mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

npm i -g \
	bash-language-server \
	vim-language-server \
	yaml-language-server
