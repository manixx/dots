FROM alpine

ENV REPO=https://dl-cdn.alpinelinux.org/alpine/edge/community

RUN apk add \
	--repository=$REPO \
	--no-cache \
	gopls \
	go
CMD ["gopls"]
