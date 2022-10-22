#
# contains all Node-based LSP servers
#

FROM node:alpine

RUN apk add --no-cache \
	tini \
	shellcheck

USER node

RUN mkdir -p ~/.npm-global \
	&& npm config set prefix '~/.npm-global'

ENV HOME /home/node
ENV PATH ${HOME}/.npm-global/bin:${PATH}

RUN npm install --location=global \
	typescript \
	typescript-language-server \
	bash-language-server \
	yaml-language-server \
	dockerfile-language-server-nodejs \
	vscode-langservers-extracted

ENTRYPOINT ["/sbin/tini", "--"]
