#!/bin/zsh 

switch_git_branch_widget() {
	if ! git rev-parse --git-dir 2>&1 1>/dev/null; then
		zle reset-prompt
		return 1
	fi

	local branch=$(git branch -a -v \
		| sed 's|remotes/\w*/||g' \
		| sed '/HEAD/d' | sed '/*/d' \
		| sed 's|^\s*||g' \
		| sed 's|^\([A-Z0-9a-z_\/\-]*\)\s*|\1\t|g' \
		| column -s $'\t' -t -T 2 -c 150 \
		| sort -k 1,1 \
		| uniq \
		| fzf --ansi --height 40% \
		| cut -d ' ' -f 1 \
		| xargs)

	[[ ! -z ${branch} ]] && git checkout ${branch} 
	zle reset-prompt
}

zle     -N   switch_git_branch_widget
bindkey '^g' switch_git_branch_widget

