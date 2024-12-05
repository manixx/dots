#!/bin/zsh

for f in *.Dockerfile; do
	p=${f%.*}
	docker build -t lsp-containers/${p} -f $f .
done
