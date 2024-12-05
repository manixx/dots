FROM node:22-alpine

#RUN apk add --no-cache \
#	shellcheck \
RUN npm i -g \
	bash-language-server
ENV BASH_IDE_LOG_LEVEL=debug
CMD ["bash-language-server", "start"]
