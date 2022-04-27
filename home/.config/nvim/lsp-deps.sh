#!/bin/sh

sudo xbps-install -Sy \
	nodejs \
	gopls

npm i -g \
	bash-language-server \
	vim-language-server \
	yaml-language-server
