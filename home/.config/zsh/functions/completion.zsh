if command -v gh &> /dev/null; then
	eval $(gh completion -s zsh)
fi

if command -v helm &> /dev/null; then
	source <(helm completion zsh)
fi

if command -v terraform &> /dev/null; then
	complete -C /usr/bin/terraform terraform
fi
