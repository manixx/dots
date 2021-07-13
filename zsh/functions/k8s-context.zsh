#!/bin/zsh

print_k8s_context() {
	if command -v kubectl > /dev/null; then
		echo -n $(kubectl config current-context)
	fi
}
